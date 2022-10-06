# ----- cond -> el cond es el equivalente del else if
cond do
	2 + 2 == 5 -> IO.puts "This will not be true"
	2 * 2 == 3 -> IO.puts "Nor this"
	1 + 1 == 2 -> IO.puts "But this will"
end
#//"But this will"


# Si las condiciones retornan nil or false, saldrá error 'CondClauseError'
# para evitar eso se debe colocar una condicón true que siempre se cumpla
cond do
	2 + 2 == 5 -> IO.puts "This is never true"
	2 * 2 == 3 -> IO.puts "Nor this"
	true -> IO.puts "This is always true (equivalent to else)"
end
#//"This is always true (equivalent to else)"


# Por último, cond considera como verdadero cualquier valor que no sea nil o false:
cond do
	hd([1, 2, 3]) -> IO.puts "1 is considered as true"
end
#//"1 is considered as true"