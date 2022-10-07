# ------------- The IO module ----------------------------------------------------------------
# Es el principal mecanismo de Elixir para leer y escribir en la entrada/salida
# estándar (:stdio), el error estándar (:stderr), los archivos y otros dispositivos IO
IO.puts("hello world")            #=> hello world
                                  #=> :ok
IO.gets("yes or no? ")            #=> yes or no? yes //Pedir datos al usuario
                                  #=> "yes\n"

# Por defecto, las funciones del módulo IO leen de la entrada estándar y escriben en la salida
# estándar. Podemos cambiar esto pasando, por ejemplo:
IO.puts(:stderr, "hello world")   #// :standard_error(stderr) escribe en el dispositivo de error estándar

# ------------- The File module ----------------------------------------------------------------
"""
El módulo File contiene funciones que nos permiten abrir archivos como dispositivos IO. Por defecto, los
archivos se abren en modo binario, lo que requiere que los desarrolladores utilicen las funciones específicas
IO.binread/2 e IO.binwrite/2
"""
"""
iex> {:ok, file} = File.open("path/to/file/hello", [:write]) #=> {:ok, #PID<0.47.0>}
IO.binwrite(file, "world")                              #=> :ok
File.close(file)                                        #=> :ok
File.read("path/to/file/hello")                         #=> {:ok, "world"}
"""

"""
El módulo File tiene muchas funciones para trabajar con el sistema de archivos. Ejemplo:
  * File.rm/1 -> puede utilizarse para eliminar archivos
  * File.mkdir/1 -> para crear directorios
  * File.mkdir_p/1 -> para crear directorios y toda su cadena padre
  * File.cp_r/2 y File.rm_rf/1 -> para copiar y eliminar respectivamente archivos y directorios de forma
    #recursiva (es decir, copiando y eliminando también el contenido de los directorios)
"""

# las funciones del módulo File tienen dos variantes: una "normal" y otra con un signo de exclamación final (!)
# Ejemplo: File.read/1. Alternativamente File.read!/1:
"""
iex> File.read("path/to/file/hello")     #=> {:ok, "world"}
iex> File.read!("path/to/file/hello")    #=> "world" //solo devuelve el contenido
"""

# La versión sin ! es preferible cuando se desea manejar diferentes resultados utilizando la concordancia de patrones
"""
case File.read("path/to/file/hello") do
  {:ok, body} -> # do something with the `body`
  {:error, reason} -> # handle the error caused by `reason`
end
"""

# -------------------- The path module ----------------------------------------------------------------
# La mayoría de las funciones del módulo File esperan rutas como argumentos. Lo más habitual es que esas rutas
# sean binarios normales. El módulo Path proporciona facilidades para trabajar con dichas rutas
"""
iex> Path.join("foo", "bar")    #=> "foo/bar"
iex> Path.expand("~/hello")     #=> "/Users/crist/hello"
"""
# Es preferible utilizar las funciones del módulo Path en lugar de manipular directamente las cadenas, ya que
# el módulo Path se ocupa de los diferentes sistemas operativos de forma transparente
