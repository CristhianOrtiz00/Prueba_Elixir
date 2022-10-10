# ----- Keyword list -> son una estructura de datos utilizada para pasar opciones a
# las funciones. 
String.split("1 2 3", " ")		#//["1", "2", "3"]
String.split("1  2  3", " ")	#//["1", "", "2", "", "3"] -> Ya que tiene dos espacios
String.split("1  2  3", " ", [trim: true])	#//["1", "2", "3"] -> elimina los datos vacios

# [trim: true] es una lista de palabras clave. Además, cuando una Keyword lists
# es el último argumento de una función, podemos omitir los paréntesis
String.split("1  2  3", " ", trim: true)

# las Keyword lists son tuplas de 2 elementos en las que el primer elemento
# (la clave) es un átomo y el segundo puede ser cualquier valor
[{:trim, true}] == [trim: true]	#//true

# Como las Keyword lists son listas, podemos utilizar todas las operaciones
# disponibles para las listas. Por ejemplo, podemos utilizar ++ para añadir nuevos valores
list = [a: 1, b: 2]		#//[a: 1, b: 2]
list ++ [c: 3]			#//[a: 1, b: 2, c: 3]
[a: 0] ++ list			#//[a: 0, a: 1, b: 2]
IO.puts list[:a]		#//1
IO.puts list[:b]		#//2

# En caso de claves duplicadas, los valores que se añaden al frente son los que se obtienen:
new_list = [a: 0] ++ list	#//[a: 0, a: 1, b: 2]
new_list[:a]				#//0

# Las Keyword lists son importantes porque tienen tres características
# especiales:
# Las claves deben ser átomos.
# Las claves están ordenadas, según lo especificado por el desarrollador.
# Las claves pueden darse más de una vez.

# Aunque se puede hacer una coincidencia de patrones en Keyword lists,
# en la práctica rara vez se hace, ya que la coincidencia de patrones en listas
# requiere el número de elementos y su orden para coincidir

[d: d] = [d: 1]
IO.puts d					#//1
#[a: a] = [a: 1, b: 2]		#//(MatchError)
#[b: b, a: a] = [a: 1, b: 2]#//(MatchError)

# Si necesita almacenar muchos elementos o garantizar la asociación de una clave
# con un valor como máximo, debería utilizar mapas en su lugar