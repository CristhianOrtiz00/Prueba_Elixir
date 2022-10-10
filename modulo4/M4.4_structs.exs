# ------------------ Defining structs ------------------------------------------------------------------------
defmodule User do
  defstruct name: "John", age: 27
end
#%User{}               #=> %User{age: 27, name: "John"} //da un error
#%User{name: "Jane"}   #=> %User{age: 27, name: "Jane"}

# ------------------ Accessing and updating structs ----------------------------------------------------------
# Cuando discutimos los mapas, mostramos cómo podemos acceder y actualizar los campos de un mapa. Las mismas
# técnicas (y la misma sintaxis) también se aplican a las estructuras
"""
iex> john = %User{}                 #=> %User{age: 27, name: "John"}
iex> john.name                      #=> "John"
iex> jane = %{john | name: "Jane"}  #=> %User{age: 27, name: "Jane"}
"""

# Las estructuras también pueden utilizarse en la comparación de patrones
"""
iex> %User{name: name} = john       #=> %User{age: 27, name: "John"}
iex> name                           #=> "John"
iex> %User{} = %{}
#** (MatchError) no match of right hand side value: %{}
"""

# -------------------- Structs are bare maps underneath ----------------------------------------------------
"""
la coincidencia de patrones funciona porque debajo de los structs hay mapas desnudos con un conjunto
fijo de campos. Como mapas, los structs almacenan un campo "especial" llamado __struct__ que contiene
el nombre del struct
"""
#iex> is_map(john)       #=> true
#iex> john.__struct__      #=> User

# Note: nos referimos a las estructuras como mapas desnudos porque ninguno de los protocolos implementados
# para los mapas está disponible para las estructuras.

# Sin embargo, dado que las estructuras son solo mapas, funcionan con las funciones del módulo map:
"""
iex> jane = Map.put(%User{}, :name, "Jane")     #=> %User{age: 27, name: "Jane"}
iex> Map.merge(jane, %User{name: "John"})       #=> %User{age: 27, name: "John"}
iex> Map.keys(jane)                             #=> [:__struct__, :age, :name]
"""
# Las estructuras junto con los protocolos proporcionan una de las características más
# importantes para los desarrolladores de Elixir:

# ------------------------ Default values and required keys -----------------------------------------
# Si no se especifica un valor de clave por defecto al definir una estructura, se asumirá nil
"""
defmodule Product do
  defstruct [:name]
end
%Product{}            #=> %Product{name: nil}
"""

# Puede definir una estructura que combine tanto campos con valores por defecto explícitos, como
# valores nil implícitos. En este caso, primero debe especificar los campos que implícitamente son nil,
# si no genera un error de sintaxis
"""
defmodule User do
  defstruct [:email, name: "John", age: 27]
end
%User{}               #=> %User{age: 27, email: nil, name: "John"}
"""

# se puede obligar a que se especifiquen ciertas claves al crear la estructura mediante el atributo de módulo
# @enforce_keys
"""
defmodule Car do
  @enforce_keys [:make]
  defstruct [:model, :make]
end
%Car{}
#** (ArgumentError) the following keys must also be given when building struct Car: [:make]
"""
