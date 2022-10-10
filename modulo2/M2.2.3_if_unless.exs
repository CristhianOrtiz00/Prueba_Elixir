# if es para ejecutar algo si la condición es verdadera
# unless es para ejecutar a menos que la condición sea verdadera
# si alguna de las dos no entra al body retorna nil
# son implementados macros en el lenguaje y no como construcciones especiales

if true do
	IO.puts "This works!"
end
#//"This works!"
unless true do
	IO.puts "This will never be seen"
end
#//nil

# bloques de is and else
if nil do
	IO.puts "This won't be seen"
else
	IO.puts "This will"
end
#//"This will"


# Ámbito de las variables en Elixir -> Si cualquier variable es declarada o cambiada
# dentro de las construcciones if, case y similares, la declaración y el cambio sólo 
# serán visibles dentro de la construcción
x = 1
if true do
	x = x + 1
	IO.puts x	#//2
end
IO.puts x		#//1

# Para notar el cambio de la variable debe retornar lo que de el if
x = if true do
	x + 3
else
	x
end
IO.puts x		#//4