# ----- Case -> este es como el switch
x = 2
case {1, 2, 3} do
	{4, 5, 6} ->
		IO.puts "This clause won't match"
	{1, x, 3} ->
		IO.puts "This clause will match and bind x to 2 in this clause"
	_ ->
		IO.puts "This clause would match any value"
end
#//"This clause will match and bind x to 2 in this clause"

# Para hacer coincidir con una variable debe utilizar '^'
x = 1
case 10 do
	^x -> IO.puts "Won't match"
	_ -> IO.puts "Will match"
end
#//"Will match"

# Se pueden agregar condiciones(guards) al case
# Algunos de los guards:
# comparison operators (==, !=, ===, !==, <, <=, >, >=)
# strictly boolean operators (and, or, not). Note &&, ||, and !
# arithmetic unary operators (+, -)
# arithmetic binary operators +, -, *, /)
# in and not in operators (el lado derecho debe ser una list or a range)
# "type-check" functions (is_list/1, is_number/1, and the like)
# functions that work on built-in datatypes (abs/1, hd/1, map_size/1, and others)

IO.puts x
case {1, 2, 3} do
	{1, x, 3} when x > 0 -> # Si x > 0 funciona así x sea diferente de 2
		IO.puts "Will match"
	_ ->
		IO.puts "Would match, if guard condition were not satisfied"
end
#//"Will match"

# Los errores en los guards hacen que el guards falle y no se tenga encuenta
# hd(1)		#//(ArgumentError) argument error
#case 1 do
#	x when hd(x) -> "Won't match"
#	x -> "Got #{x}"
#end
#//"Got 1"

# Si ninguna clusula coincide se produce error
# case :ok do
#	 :error -> "Won't match"
# end
#//(CaseClauseError) no case clause matching: :ok

# Note: Los guards se pueden utilizar en muchas sentencias, como en funciones anonimas
f = fn
	x, y when x > 0 -> x + y
	x, y -> x * y
end
IO.puts f.(1, 3)		#//4
IO.puts f.(-1, 3)		#//-3

# Los argumentos deben ser iguales en cada case o se produce error
#f2 = fn
#	x, y when x > 0 -> x + y
#	x, y, z -> x * y + z
#end
#//(CompileError)