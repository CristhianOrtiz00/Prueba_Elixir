# ----- charlists -> Un charlist es una lista de enteros donde todos los enteros son
# code points válidos.
# las comillas simples crean literales de listas de caracteres
IO.puts 'hello'			#//hello
[?h, ?e, ?l, ?l, ?o]	#//hello

# una lista de caracteres contiene integer code points. Sin embargo, la lista sólo
# se imprime entre comillas simples si todos los puntos de código están dentro del
# rango ASCII
'hełło'				#//[104, 101, 322, 322, 111]
is_list('hełło')	#//true

# si se almacena una lista de enteros que se encuentran entre 0 y 127, por defecto IEx
# lo interpretará como una lista de caracteres y mostrará los caracteres ASCII correspondientes
heartbeats_per_minute = [99, 97, 116]	
IO.puts heartbeats_per_minute			#//'cat'

# You can convert a charlist to a string and back by using the to_string/1 and to_charlist/1 functions:
# Tenga en cuenta que estas funciones son polimórficas: no sólo convierten listas de caracteres en
# cadenas, sino que también operan con enteros, átomos, etc.
to_charlist("hełło")		#//[104, 101, 322, 322, 111]
to_string('hełło')			#//"hełło"
to_string(:hello)			#//"hello"
to_string(1)				#//"1"

# listas de caracteres, al ser listas, utilizan el operador de concatenación de
# listas ++
#'this ' <> 'fails'			#//(ArgumentError)
'this ' ++ 'works'			#//'this works'
#"he" ++ "llo"				#//(ArgumentError)
"he" <> "llo"				#//"hello"