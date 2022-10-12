# -- Tipos básicos --
1 			#-> integer
0x1F 		#-> integer
1.0 		#-> float
true 		#-> boolean
:atom 		#-> atom / symbol
"elixir" 	#-> string
[1, 2, 3] 	#-> list
{1, 2, 3} 	#-> tuple
x = 1				#//1
IO.puts(x)			#//1

# -- Aritmética básica
IO.puts 1 + 2		#//3
IO.puts 5 * 5		#//25
IO.puts 10 / 2 		#//5.0 -> '/' siempre devuelve un float
IO.puts div(10,2) 	#//5 -> devuelve un integer
IO.puts rem 10,3 	#//1 -> devuelve el residuo de la división

# --Admite números hexadecimales y binarios
IO.puts 0b1010		#//10 ->  transforma de numero binario a decimal
IO.puts(0o777) 		#//511 -> transforma de numero octal a decimal
IO.puts 1.0e-10		#//1.0e-10
IO.puts round(3.58) #//4 -> devueve el integer más cercano
IO.puts trunc(3.58) #//3 -> devuelve la parte entera de un float

# -- booleans --
true == false		#//false
is_boolean(true)	#//true
is_boolean(1)		#//false

# -- Atoms -> Es una constante con el mismo valor de su nombre
IO.puts :apple		#//apple
:orange				#//orange
:apple == :apple	#//true
:apple == :orange	#//false
true == :true		#//true -> el true y false son atoms
is_atom(false)		#//true
is_boolean(:false)	#//true
is_atom(Hello) 		#//true -> Los alias empiezan con mayusculas y son atom

# ----- strings -> con comillas dobles
"hello"												#//hello
string = :world								#//world
IO.puts "hello #{string}" 		#//hello world -> interpolacion de cadenas
IO.puts "hello\nworld"				#//hello
															#//world
is_binary("hello")						#//true -> Los string estan representados por secuencias contiguas de bytes
IO.puts byte_size("hellö")				#//6 -> the chart 'ö' takes 2 bytes to be represented
IO.puts String.length("hellö")		#//5
IO.puts String.upcase("hello")		#//HELLO
IO.puts String.downcase("HeLLo")	#//hello

# ----- Funciones anonimas: estan delimitadas por fn-end
#  permiten almacenar y pasar código ejecutable como si fuera un integer o string
add = fn a, b -> a + b end
IO.puts add.(1,2)				#//3
IO.puts is_function(add)		#//true
IO.puts is_function(add, 2)		#//true -> verifica si la función espera exactamente dos argumentos
double = fn a -> add.(a,a) end
IO.puts double.(2)				#//4
IO.puts f = 42
IO.puts (fn -> f = 0 end).() 	#//0 -> esta función solo afecta a la variable interior y no a la de su entorno
IO.puts f						#//42

# ----- Listas --
[1, 2, true, 3]
IO.puts length [1, 4, 5] 		#//3
list3 = [1, 2, 3] ++ [4, 5, 6] 	##//[1, 2, 3, 4, 5, 6] -> concatena las dos listas
list4 = [1, true, 2, false, 3, true] -- [true, false]	#//[1, 2, 3, true] -> resta las listas
list5 = [1, 2, 3]
hd(list5) 						#//-> 1 //retorna la cabeza de la lista (primer elemento)
tl(list5) 						#//-> [2, 3] //retorna la cola de la lista
IO.puts [104, 101, 108, 108, 111]	#//'hello' -> Elixir puede tomar la lista de numeros ASCCI imprimibles
#i 'hello' -> muestra los datos de 'hello'. Las comillas simples son listas de caracteres
'hello' == "hello" 				#//false
list = [1, 2, 3]
IO.puts list					#//[1, 2, 3]
[0] ++ list						#//-> Agrega el valor 0 al inicio de la lista
IO.puts list					#//[0, 1, 2, 3]
list ++ [4]				 		#//-> Agrega el valor 4 al final de la lista
IO.puts list					#//[1, 2, 3, 4]

# ----- Tuplas
{:ok, "hello"}
IO.puts tuple_size {:ok, "hello"} 	#//2
tuple = {:ok, "hello"}							#//{:ok, "hello"}
IO.puts elem(tuple, 1)							#//hello
put_elem(tuple, 1, "world") 				#//{:ok, "world"}
