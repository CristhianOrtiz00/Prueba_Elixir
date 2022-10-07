# ------ Default arguments
# Las funciones con nombre en Elixir también admiten argumentos predeterminados
defmodule Concat do
  def join(a, b, sep \\ " ") do
    a <> sep <> b
  end
end
IO.puts Concat.join("Hello", "world")      	#=> Hello world
IO.puts Concat.join("Hello", "world", "_")	#=> Hello_world

defmodule DefaultTest do
  def dowork(x \\ "hello") do
    x
  end
end

DefaultTest.dowork													#=> hello
DefaultTest.dowork 123											#=> 123

# Si una función con valores predeterminados tiene varias cláusulas, es necesario crear un encabezado
#	de función (una definición de función sin cuerpo) para declarar valores predeterminados:
defmodule Concat do
  # A function head declaring defaults
  def join(a, b \\ nil, sep \\ " ")

  def join(a, b, _sep) when is_nil(b) do	#//El guión bajo inicial en _sep signfica que la variable
    a																			#	será ignorada en esta función
  end

  def join(a, b, sep) do
    a <> sep <> b
  end
end
IO.puts Concat.join("Hello", "world")      #=> Hello world
IO.puts Concat.join("Hello", "world", "_") #=> Hello_world
IO.puts Concat.join("Hello")               #=> Hello


# Al usar valores predeterminados, se debe tener cuidado de evitar la superposición de definiciones de
# funciones. Considere el siguiente ejemplo:
defmodule Concat2 do
  def join(a, b) do
    IO.puts "***First join"
    a <> b
  end

  def join(a, b, sep \\ " ") do
    IO.puts "***Second join"
    a <> sep <> b
  end
end
# Elixir emitirá la siguiente advertencia:
# concat.ex:7: warning: this clause cannot match because a previous clause at line 2 always matches
# El compilador nos está diciendo que al invocar la función join con dos argumentos siempre se elegirá
# la primera definición de join mientras que la segunda sólo se invocará cuando se pasen tres argumentos:
IO.puts Concat2.join "Hello", "world"							#=> ***First join
																									#		Helloworld
IO.puts Concat2.join "Hello", "world", "_"				#=>***Second join
																									#		Hello_world
