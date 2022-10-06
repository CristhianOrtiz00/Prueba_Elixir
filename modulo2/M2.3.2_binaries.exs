# ------ Binarios
# Un binario es una cadena de bits cuyo número es divisible por 8. Esto significa que
# todo binario es una cadena de bits, pero no toda cadena de bits es un binario. Podemos
# utilizar las funciones is_bitstring/1 e is_binary/1 para demostrarlo.

is_bitstring(<<3::4>>)		#//true
is_binary(<<3::4>>)			#//false -> 4 no es divisible de 8
is_bitstring(<<0, 255, 42>>)#//true
is_binary(<<0, 255, 42>>)	#//true -> por defecto todos son binarios
is_binary(<<42::16>>)		#//true -> porque 16 es divisible por 8

# pattern match on binaries/bitstrngs
<<0, 1, x>> = <<0, 1, 2>>		#//<<0, 1, 2>>
IO.puts x						#//2
#<<0, 1, x>> = <<0, 1, 2, 3>>	#//(MatchError) -> deben tener la misma cantidad de datos

# Si se quiere coincidir con un binario de tamaño desconocido, se puede utilizar el
# modificador binario al final del patrón
<<0, 1, x::binary>> = <<0, 1, 2, 3>>#//<<0, 1, 2, 3>>
IO.puts x							#//<<2, 3>>

# Hay un par de modificadores más que pueden ser útiles cuando se hacen coincidencias
# de patrones en binarios. El modificador binary-size(n) coincidirá con n bytes en un binario:
<<head::binary-size(2), rest::binary>> = <<0, 1, 2, 3>>	#//<<0, 1, 2, 3>>
IO.puts head		#//<<0, 1>> -> toma dos datos en bytes
IO.puts rest		#//<<2, 3>>

# Una cadena es un binario codificado en UTF-8, donde el punto de código de cada carácter se
# codifica utilizando de 1 a 4 bytes. Por tanto, toda cadena es un binario, pero debido a
# las reglas de codificación del estándar UTF-8, no todo binario es una cadena válida.
is_binary("hello")				#//true
is_binary(<<239, 191, 19>>)		#//true
String.valid?(<<239, 191, 19>>)	#//false

# The string concatenation operator <> is actually a binary concatenation operator
"a" <> "ha"				#//"aha"
<<0, 1>> <> <<2, 3>>	#//<<0, 1, 2, 3>>

# Dado que las cadenas son binarios, también podemos hacer coincidir los patrones de las cadenas
<<head, rest::binary>> = "banana"	#//"banana"
head == ?b							#//true
rest								#//"anana"

# Sin embargo, recuerde que la coincidencia de patrones binarios funciona en bytes, por lo que
# la coincidencia en la cadena como "über" con caracteres multibyte no coincidirá
# con el carácter, sino con el primer byte de ese carácter:
"ü" <> <<0>>					#//<<195, 188, 0>>
<<x, rest::binary>> = "über"	#//"über"
x == ?ü							#//false -> Ya que x solo tiene el primer valor de 'ü'
rest							#//<<188, 98, 101, 114>>

# Por lo tanto, cuando se hace una coincidencia de patrones en cadenas, es importante utilizar
# el modificador utf8:
<<x::utf8, rest::binary>> = "über"	#//"über"
x == ?ü								#//true
rest								#//"ber"