# ------ Modulos
"""
Se utiliza el macro defmodule donde la primera letra del módulo debe estar en mayúscula
se utiliza el macro def para definir funciones dentro de ese módulo donde la primera letra debe estar en minúscula o _(guión bajo)
"""
defmodule MathAux do
	def sum(a, b) do
		a + b
	end
end
IO.puts MathAux.sum(1, 2)		#//3

# ----- Compilation --------------------
# Supongamos que tenemos un archivo llamado math.ex con el siguiente contenido:
"""
defmodule Math do
  def sum(a, b) do
    a + b
  end
end
"""
# This file can be compiled using elixirc: elixirc math.ex

"""
Nota: Esto generará un archivo llamado Elixir.Math.beam que contiene el bytecode para el módulo definido. Si iniciamos iex de nuevo,
nuestra definición del módulo estará disponible (siempre que iex se inicie en el mismo directorio en el que está el archivo de bytecode)

Los proyectos Elixir suelen estar organizados en tres directorios:
	_build - contiene los artefactos de compilación
	lib - contiene el código de Elixir (normalmente archivos .ex)
	test - contiene las pruebas (normalmente archivos .exs)

Cuando se trabaja en proyectos reales, la herramienta de compilación llamada mix se encargará de compilar y establecer las rutas adecuadas
para usted. Para fines de aprendizaje y conveniencia, Elixir también soporta un modo de scripted que es más flexible y no genera ningún artefacto compilado.
"""
# ----- Named functions --------------------
# Dentro de un módulo, podemos definir funciones con def/2 y funciones privadas con defp/2
defmodule Math do
	def zero?(0) do 	#-> El signo de interrogación al final significa que la función devuelve un boolean
		true
	end

	def zero?(x) when is_integer(x) do
		false
	end
end

# las funciones con nombre admiten tanto la sintaxis do: como la do-block
# podemos editar math.exs para que se vea así:
"""
defmodule Math do
  def zero?(0), do: true
  def zero?(x) when is_integer(x), do: false
end
"""
IO.puts Math.zero?(0)         #=> true
IO.puts Math.zero?(1)         #=> false
#IO.puts Math.zero?([1, 2, 3]) #=> ** (FunctionClauseError)
#IO.puts Math.zero?(0.0)       #=> ** (FunctionClauseError)

# El nombre de la función se puede recuperar con nombre como tipo de función
fun = &Math.zero?/1
IO.puts is_function(fun)			#=>true
fun.(0)												#=>true

# Las funciones locales o importadas, como is_function/1, pueden ser capturadas sin el módulo:
IO.puts (&is_function/1).(fun)				#=>true

# You can also capture operators:
add = &+/2
IO.puts add.(1, 2)										#=>3

# Nota: la sintaxis de captura también puede utilizarse como un atajo para crear funciones:
fun = &(&1 + 1)
IO.puts fun.(1)								#=>2
fun2 = &"Good #{&1}"
IO.puts fun2.("morning")			#=>Good morning

"""
El &1 representa el primer argumento que se pasa a la función. &(&1 + 1) de arriba es
exactamente lo mismo que fn x -> x + 1 end.
La sintaxis anterior es útil para definicionesde funciones cortas.
"""
