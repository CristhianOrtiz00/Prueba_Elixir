# ------------------- Processes -----------------------------------------------------------
"""
Se puede notar que File.open/2 devuelve una tupla: {:ok, pid}. Esto sucede porque el módulo IO trabaja con procesos.
Al modelar los dispositivos IO con procesos, la VM Erlang permite que los mensajes IO se dirijan entre
diferentes nodos que ejecutan Erlang Distribuido o incluso intercambiar archivos para realizar operaciones
de lectura/escritura entre nodos
"""

# ------------------- iodata and chardata -----------------------------------------------------------
"""
En todos los ejemplos anteriores, usamos binarios al escribir en archivos. Sin embargo, la mayoría de
las funciones de E/S en Elixir también aceptan "iodata" o "chardata". Una de las principales razones
para usar "iodata" y "chardata" es para el rendimiento.
"""
name = "Mary"
IO.puts("Hello " <> name <> "!")      #=> //para string cortos no importa mucho utilizar esta estructura
# Por esta razón las funciones E/S permiten usar lista de string
IO.puts(["Hello ", name, "!"])        #=> //pueden simplificar el procesamiento de las cadenas en varios escenarios

# Por ejemplo, imagina que tienes una lista de valores, como ["manzana", "plátano", "limón"] que quieres escribir
# en el disco separados por comas
Enum.join(["apple", "banana", "lemon"], ",")        #=> "apple,banana,lemon"
Enum.intersperse(["apple", "banana", "lemon"], ",") #=> ["apple", ",", "banana", ",", "lemon"]
IO.puts(["apple", [",", "banana", [",", "lemon"]]]) #=> //también pueden contener listas anidadas de string
# También pueden contener enteros
IO.puts(["apple", ?,, "banana", ?,, "lemon"])       #=> ?, es el entero que representa una coma

"""
La diferencia entre "iodata" y "chardata" es precisamente lo que representa dicho entero.
  Para iodata, los enteros representan bytes.
  Para chardata, los enteros representan puntos de código Unicode
"""

# Finalmente, hay una última construcción llamada charlist, que es un caso especial de chardata en el
# que tenemos una lista en la que todos sus valores son enteros que representan puntos de código Unicode.
# Se pueden crear con el sigilo ~c
~c"hello"         #=> 'hello'
[?a, ?b, ?c]      #=> 'abc'


"""
RESUMEN:
iodata y chardata son listas de binarios y enteros. Esos binarios y enteros pueden ser anidados arbitrariamente
dentro de las listas. Su objetivo es dar flexibilidad y rendimiento cuando se trabaja con dispositivos y archivos IO

la elección entre iodata y chardata depende de la codificación del dispositivo IO. Si el archivo se abre sin
codificación, el archivo espera iodata, y se deben utilizar las funciones del módulo IO que empiezan por bin*.
El dispositivo IO por defecto (:stdio) y los ficheros abiertos con codificación :utf8 esperan chardata y funcionan
con el resto de funciones del módulo IO.
"""
