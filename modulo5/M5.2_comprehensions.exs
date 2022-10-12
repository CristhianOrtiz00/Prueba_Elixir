# ----------- Comprehensions ----------------------------------------------------
# for
for n <- [1, 2, 3, 4], do: n * n      #=> [1, 4, 9, 16]

# Una comprensión se compone de tres partes: generadores, filtros y coleccionables.

# ---------------- Generators and filters ---------------------------------------n
# In the expression above, n <- [1, 2, 3, 4] is the generator.
# Las expresiones generadoras también admiten la coincidencia de patrones en su lado izquierdo;
# todos los patrones que no coinciden se ignoran.
values = [good: 1, good: 2, bad: 3, good: 4]
for {:good, n} <- values, do: n * n      #=> [1, 4, 16] // las keys que no sean :good se ignoran

# los filtros se pueden usar para seleccionar algunos elementos particulares.
for n <- 0..5, rem(n, 3) == 0, do: n * n  #=> [0, 9]

# Además, las comprensiones también permiten dar múltiples generadores y filtros. Este es un ejemplo
# que recibe una lista de directorios y obtiene el tamaño de cada archivo en esos directorios:
"""
dirs = ['/home/mikey', '/home/james']

for dir <- dirs,
    file <- File.ls!(dir),
    path = Path.join(dir, file),
    File.regular?(path) do
  File.stat!(path).size
end
"""
#  se pueden utilizar múltiples generadores para calcular el producto cartesiano de dos listas
for i <- [:a, :b, :c], j <- [1, 2], do:  {i, j}   #=> [a: 1, a: 2, b: 1, b: 2, c: 1, c: 2]

# ---------------------- Bitstring generators --------------------------------------------------
"""
Los generadores de cadenas de bits también son compatibles y son muy útiles cuando necesita comprender
los flujos de cadenas de bits. El siguiente ejemplo recibe una lista de píxeles de un binario con sus
respectivos valores rojos, verdes y azules y los convierte en tuplas de tres elementos cada uno.:
"""
pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
  for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}     #=> [{213, 45, 132}, {64, 76, 32}, {76, 0, 0}, {234, 32, 15}]

# ----------------------- The :into option ---------------------------------------------------------
# el resultado de una comprensión puede insertarse en diferentes estructuras de datos pasando la opción :into a la comprensión
# se utiliza un generador de cadenas de bits con la opción :into para eliminar todos los espacios de una cadena:
for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>   #=> helloworld

# Los conjuntos, mapas y otros diccionarios también pueden ser pasados a la opción :into. En general,
# :into acepta cualquier estructura que implemente el protocolo Collectable.

# transformación de valores en un mapa:
for {key, val} <- %{"a" => 1, "b" => 2}, into: %{}, do: {key, val * val}    #=> %{"a" => 1, "b" => 4}

# Una terminal de eco que devuelve la versión ascendente de lo que se teclea puede ser implementada usando comprensiones
stream = IO.stream(:stdio, :line)
for line <- stream, into: stream do
  String.upcase(line) <> "\n"
end

# Comprehensions support other options, such as :reduce and :uniq
# Examples whit :uniq
for x <- [1, 1, 2, 3], uniq: true, do: x * 2                #=> [2, 4, 6]

for <<x <- "abcabc">>, uniq: true, into: "", do: <<x - 32>> #=> "ABC"

# Example whit :reduce
for <<x <- "AbCabCABc">>, x in ?a..?z, reduce: %{} do
  acc -> Map.update(acc, <<x>>, 1, & &1 + 1)
end                                               #=> %{"a" => 1, "b" => 2, "c" => 1}
