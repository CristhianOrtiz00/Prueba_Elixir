# --------------------------------- Protocols ---------------------------------------------------------
# Los protocolos son un mecanismo para lograr polimorfismo en Elixir cuando se quiere que el comportamiento
# varíe en función del tipo de datos.
defmodule Utility do
  def type(value) when is_binary(value), do: "string"
  def type(value) when is_integer(value), do: "integer"
  # ... other implementations ...
end

# Así es como podríamos escribir la misma funcionalidad de Utility.type/1 como un protocolo:
defprotocol Utility do
  @spec type(t) :: String.t()
  def type(value)
end

defimpl Utility, for: BitString do
  def type(_value), do: "string"
end

defimpl Utility, for: Integer do
  def type(_value), do: "integer"
end

Utility.type("foo")               #=> "string"
Utility.type(123)                 #=> "integer"

"""
Con los protocolos, sin embargo, ya no estamos atascados teniendo que modificar continuamente el mismo
módulo para soportar más y más tipos de datos. Por ejemplo, podríamos obtener las llamadas defimpl
anteriores y repartirlas en varios archivos y Elixir despachará la ejecución a la implementación
apropiada basada en el tipo de datos.

En Elixir, hay dos modismos para comprobar cuántos elementos hay en una estructura de datos: longitud
y tamaño. longitud significa que la información debe ser calculada. Por ejemplo, length(list) necesita recorrer
toda la lista para calcular su longitud. Por otro lado, tuple_size(tuple) no dependen del tamaño de la tupla y
del binario, ya que la información sobre el tamaño se calcula previamente en la estructura de datos.
"""
# Implementamos un protocolo de tamaño génerico que implementaran todas las estructuras de datos para las que se
# precalcula el tamaño.

defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

Size.size("foo")                    #=> 3
Size.size({:ok, "hello"})           #=> 2
Size.size(%{label: "some label"})   #=> 1

# It’s possible to implement protocols for all Elixir data types:
# Atom, BitString, Float, Function, Integer, List, Map, pID, POrt, Reference, Tuple

# -------------------------- Protocols and structs -------------------------------------------------------
"""
El poder de la extensibilidad de Elixir viene cuando los protocolos y los structs se utilizan juntos.

Los structs son mapas, no comparten implementaciones de protocolo con los mapas. Por ejemplo, los MapSets
(conjuntos basados en mapas) se implementan como structs.

En lugar de compartir la implementación del protocolo con los mapas, los structs requieren su
propia implementación del protocolo.
"""
defimpl Size, for: MapSet do
  def size(set), do: MapSet.size(set)
end
"""
crear tu propia semántica para el tamaño de tu estructura. No sólo eso, podrías usar structs para construir
tipos de datos más robustos, como colas, e implementar todos los protocolos relevantes, como Enumerable y
posiblemente Size, para este tipo de datos.
"""
defmodule User do
  defstruct [:name, :age]
end

defimpl Size, for: User do
  def size(_user), do: 2
end

# ------------------- Implementing Any ----------------------------------------------------------
"""
Implementar manualmente los protocolos para todos los tipos puede volverse rápidamente repetitivo y tedioso.
En estos casos, Elixir proporciona dos opciones: podemos derivar explícitamente la implementación del protocolo
para nuestros tipos o implementar automáticamente el protocolo para todos los tipos.
"""

# --------------------------------- Deriving -------------------------------------------------------
# implement Any as follows:
defimpl Size, for: Any do
  def size(_), do: 0
end
# Con esto todos los tipos de datos (incluidos los structs) que no hayan implementado el protocolo Size
# se considerarán de tamaño 0.

# para utilizar dicha implementación tendríamos que decirle a nuestro struct que derive explícitamente el protocolo Size
defmodule OtherUser do
  @derive [Size]
  defstruct [:name, :age]
end

# ----------------------------- Fallback to Any --------------------------------------------------------
# Otra alternativa a @derive es indicar explícitamente al protocolo que recurra a Any cuando no se pueda
# encontrar una implementación.
defprotocol Size do
  @fallback_to_any true
  def size(data)
end
# Para la mayoría de los protocolos, lanzar un error cuando un protocolo no está implementado es el comportamiento adecuado.

# ----------------------------- Built-in protocols(Protocolos integrados) ---------------------------------------
# Elixir viene con algunos protocolos incorporados como los del módulo Enum. que proporciona muchas funciones
# que funcionan con cualquier estructura de datos que implemente el protocolo Enumerable.
Enum.map([1, 2, 3], fn x -> x * 2 end)    #=> [2, 4, 6]

# Otro ejemplo útil es el protocolo String.Chars
to_string :hello                          #=> hello

# Observe que la interpolación de cadenas en Elixir llama a la función to_string
"age: #{25}"                              #=> age: 25

# El fragmento anterior sólo funciona porque los números implementan el protocolo String.Chars.
# Si se pasa una tupla se producirá un error:
"""
tuple = {1, 2, 3}
"tuple: # {tuple}"
#=> ** (Protocol.UndefinedError) protocol String.Chars not implemented for {1, 2, 3}
"""

# Cuando se necesita "imprimir" una estructura de datos más compleja, se puede utilizar
# la función inspect, basada en el protocolo Inspect
"tuple: #{inspect tuple}"                 #=> "tuple: {1, 2, 3}"

# Note: El protocolo Inspect es el protocolo utilizado para transformar cualquier
# estructura de datos en una representación textual legible.

{1, 2, 3}
%User{}
%User{name: "john", age: 27}
inspect &(&1+2)             #//"#Function<6.71889879/1 in :erl_eval.expr/5>"
