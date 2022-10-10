# Unicode -> facilita la comunicación a través de múltiples idiomas.
# EL estandar unicode actúa como un registro de practicamente todos los caracteres
# que se conocen: esto incluye caracteres de textos clásicos, emojis y caracteres de formato y control

#Code Point -> valor único numérico
IO.puts ?a			#//97 //? con este simbolo se obtiene el valor númerico de ese caracter
IO.puts ?ł			#//322

# La mayoría de los gráficos de código Unicode se referirán a un punto de código por
# su representación hexadecimal (hexadecimal). Ejemplo 97 se traduce a 0061 en hexadecimal
# podemos representar cualquier caracter unicode en una cadena Elixir así \uXXXX donde las
# X son el número hexadecimal

"\u0061" == "a"		#//true
0x0061 = 97 = ?a	#//97

String.codepoints("👩‍🚒")				  #//["👩", "‍", "🚒"]
IO.puts String.graphemes("👩‍🚒")		#//["👩‍🚒"]
String.length("👩‍🚒")					    #//1

# Para ver los bytes exactos de una cadena almacenada se puede hacer concatenando
# el byte nulo <<0>> o con IO.inspect/2
"hełło" <> <<0>>
IO.inspect("hełło", binaries: :as_binaries)

# ------ Cadenas de bites -> Una cadena de bits está hecha de muchos segmentos y
# cada segmento tiene un tipo. Hay 9 tipos utilizados en las cadenas de bits:
# integer, float, bits ó bitstring, binary ó bytes, utf8, utf16, utf32

# When no type is specified, the default is integer
<<1, 2, 3>>				#//<<1, 2, 3>>
# Elixir también acepta de forma predeterminada que el segmento sea una cadena literal que se expande a enteros
<<0, "foo">>			#//<<0, 102, 111, 111>>
# Los binarios deben etiquetarse explícitamente como:binary
rest = "oo"
<<102, rest::binary>>	#//"foo"

# Los tipos utf8, utf16 y utf32 son para puntos de código Unicode. También pueden
# aplicarse a cadenas literales y listas de caracteres:
<<"foo"::utf16>>		#//<<0, 102, 0, 111, 0, 111>>
<<"foo"::utf32>>		#//<<0, 0, 0, 102, 0, 0, 0, 111, 0, 0, 0, 111>>
# De lo contrario, obtendremos un (ArgumentError) al construir el binario:
# <<102, rest>>			#//(ArgumentError) argument error

# Por defecto, se utilizan 8 bits (es decir, 1 byte) para almacenar cada número en
# una cadena de bits, pero se puede especificar manualmente el número de bits mediante
# un modificador ::n para denotar el tamaño en n bits, o se puede utilizar la declaración
# más verbosa ::size(n)
<<42>> == <<42::8>>		#//true
# <<3::4>> ó <<3::size(4)>>
<<0::1, 0::1, 1::1, 1::1>> == <<3::4>>	#//true


# Cualquier valor que exceda lo que puede ser almacenado por el número de bits provisionados es truncado

# Aquí, 257 en base 2 se representaría como 100000001, pero como hemos reservado sólo
# 8 bits para su representación (por defecto), el bit más a la izquierda se ignora y
# el valor se trunca a 00000001, o simplemente 1 en decimal.
