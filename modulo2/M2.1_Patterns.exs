#Sirve para emarejar patrones de tuplas y listas
{a, b, c} = {:hello, "world", 42}	#//{:hello, "world", 42}

[d, e, f] = [1, 2, 3]				#//[1, 2, 3]

IO.puts(a)			#//hello
IO.puts(b)			#//world
IO.puts(c)			#//42
IO.puts(d)			#//1
IO.puts(e)			#//2
IO.puts(f)			#//3

#{g, h, i} = {:hello, "world"}		#//(MatchError) -> debe tener la misma canidad de datos

#{j, k, l} = [:hello, "world", 42]	#//(MatchError) -> Deben ser del mismo tipo

{:ok, result} = {:ok, 13}			#//{:ok, 13} -> Este ejemplo dice que el lado izq solo coincidirá con el der
									#cuando el lado derecho es una tupla que comienza con :ok

[head | tail] = [1, 2, 3]			#//[1, 2, 3] -> La lista admidte la coincidencia en su cabeza y cola

IO.puts(result)			#//13
IO.puts(head)			#//1
IO.puts(tail)			#//[2, 3]

#[head | tail] = []		#//(MatchError) -> No se puede coincidir una lista vacía con un pattern de cabeza y cola

x = 1					#//1
#x = 2					#//2 -> Esto se puede ya que las variables en Elixir pueden ser de rebote
#^x = 2					#//(MatchError) -> el simbolo pin(^) evita que la variable se enlace con otro valor

[^x, 2, 3] = [1, 2, 3]	#//[1, 2, 3]
{y, ^x} = {2, 1}		#//{2, 1}
IO.puts y				#//2
#{y, ^x} = {2, 2}		#//(MatchError) -> Ya que x esta enlazado a 1

[head | _] = [33, 2, 3]	#//[1, 2, 3] -> el valor subraya(_) da a entender que no interesa la cola de la lista
IO.puts head			#//33
#_						#//(CompileError) iex:1: invalid use of _. "_" represents a value to be ignored in a pattern and cannot be used in expressions

#length([1, [2], 3]) = 3	#//(CompileError) iex:1: cannot invoke remote function :erlang.length/1 inside match
							#-> No se puede hacer el llamado de funciones en el lado izq de una coincidencia
