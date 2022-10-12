# ------ Enumerables ------------------------------------------------------------------------------------------
# Elixir proporciona el concepto de enumerables y el módulo Enum para trabajar con ellos.
# Entre ellos las listas y mapas.
Enum.map([1, 2, 3], fn x -> x * 2 end)               #=> [2, 4, 6]
Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end)  #=> [2, 12]

# El módulo proporciona una amplia gama de funciones para transformar, ordenar, agrupar,
# filtrar y recuperar elementos de enumerables

# Decimos que las funciones del módulo Enum son polimórficas porque pueden trabajar con diversos tipos de datos.

# ----- Eager vs Lazy -------------------------------------------------------------------------------------
"""
Todas las funciones del módulo Enum son eager. Muchas funciones esperan un enumerable y devuelven una lista.
Esto significa que al realizar múltiples operaciones con Enum, cada operación va a generar una lista
intermedia hasta llegar al resultado
"""
odd? = &(rem(&1, 2) != 0)
Enum.filter(1..3, odd?)                   #=> [1, 3]

# ----- The pipe operator(Operador de tuberría) ----------------------------------------------------------
1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum()  #=> 7500000000
# El símbolo |> es el operador de tubería: toma la salida de la expresión izquierda y la pasa como primer
# argumento a la función de la derecha
"""
Empezamos con un rango y luego multiplicamos cada elemento del rango por 3. Esta primera operación creará
y devolverá una lista con 100_000 elementos. A continuación, mantenemos todos los elementos impares de la
lista, generando una nueva lista, ahora con 50_000 elementos, y luego sumamos todas las entradas.
"""
# example above rewritten without using the |> operator:
Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?))          #=> 7500000000

# ------- Streams -----------------------------------------------------------------------------------------
# As an alternative to Enum, Elixir proporciona el módulo Stream que soporta operaciones lazy. Lo que significa
# que realiza solo lo que es necesario.
1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum#=> 7500000000
"""
En lugar de generar listas intermedias, los flujos construyen una serie de cálculos que se invocan sólo
cuando pasamos el flujo subyacente al módulo Enum. Los flujos son útiles cuando se trabaja con colecciones
grandes, posiblemente infinitas.También proporciona funciones para crear flujos. Por ejemplo:
Stream.cycle/1 se puede utilizar para crear un flujo que hace un ciclo infinito de un enumerable dado
"""

stream = Stream.cycle([1, 2, 3])
Enum.take(stream, 10)                   #=> [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]

# Por otro lado, Stream.unfold/2 puede utilizarse para generar valores a partir de un valor inicial dado
stream = Stream.unfold("hełło", &String.next_codepoint/1)
Enum.take(stream, 3)                   #=> ["h", "e", "ł"]

# Otra función interesante es Stream.resource/3, que puede utilizarse para envolver recursos, garantizando
# que se abran justo antes de la enumeración y se cierren después, incluso en caso de fallos
"""
stream = File.stream!("path/to/file")
%File.Stream{
  line_or_bytes: :line,
  modes: [:raw, :read_ahead, :binary],
  path: "path/to/file",
  raw: true
}
Enum.take(stream, 10)
"""
# El ejemplo anterior recuperará las 10 primeras líneas del archivo que haya seleccionado. Esto significa que
# los flujos pueden ser muy útiles para manejar archivos grandes o incluso recursos lentos como los de la red
