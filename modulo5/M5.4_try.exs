# ----------------- Errors -----------------------------------------
# También puedes definir tus propios errores creando un módulo y utilizando la construcción defexception dentro de él.
"""
defmodule MyError do
  defexception message: "default message"
end
raise MyError                             #=> ** (MyError) default message
raise MyError, message: "custom message"  #=> ** (MyError) custom message
"""
# Los errores pueden ser rescatados utilizando la construcción try/rescue
try do
  raise "oops"
rescue
  e in RuntimeError -> e
end                               #=> %RuntimeError{message: "oops"}

# Si no hay ningún uso para la excepción, no es necesario pasar una variable al rescate:
try do
  raise "oops"
rescue
  RuntimeError -> "Error!"
end                               #=> "Error!"

# In practice, Elixir developers rarely use the try/rescue construct.
# Elixir, en cambio, proporciona una función File.read/1 que devuelve una tupla que contiene
# información sobre si el archivo se abrió con éxito:
File.read("hello")                  #=> {:error, :enoent}
File.write("hello", "world")        #=> :ok
File.read("hello")                  #=> {:ok, "world"}

# En caso de que quiera manejar múltiples resultados de la apertura de un archivo, puede utilizar
# la coincidencia de patrones utilizando la construcción case:
case File.read("hello") do
  {:ok, body} -> IO.puts("Success: #{body}")
  {:error, reason} -> IO.puts("Error: #{reason}")
end

# -------------------- Fail fast / Let it crash -----------------------------------------
# Una situación en la que podemos querer usar estas construcciones es para la observabilidad/monitorización.
# Imagina que quieres registrar que algo salió mal, podrías hacer:
try do
  #... some code ...
rescue
  e ->
    Logger.error(Exception.format(:error, e, __STACKTRACE__))
    reraise e, __STACKTRACE__
end
# rescatamos la excepción, la registramos y la volvemos a lanzar. Usamos la construcción __STACKTRACE__
# tanto cuando formateamos la excepción como cuando la re-lanzamos.

# ------------------ Throws ---------------------------------------------------
"""
En Elixir, un valor puede ser lanzado y posteriormente ser capturado. throw y catch están reservados
para situaciones en las que no es posible recuperar un valor a menos que se utilice throw y catch.
Por ejemplo, imaginemos que el módulo Enum no proporciona ninguna API para encontrar un valor y
que necesitamos encontrar el primer múltiplo de 13 en una lista de números:
"""
try do
  Enum.each(-50..50, fn x ->
    if rem(x, 13) == 0, do: throw(x)
  end)
  "Got nothing"
catch
  x -> "Got #{x}"
end                                   #=> "Got -39"

# -------------------- Exits ----------------------------------------------------
# Todo el código de Elixir se ejecuta dentro de procesos que se comunican entre sí. Cuando un proceso muere
# por "causas naturales" (por ejemplo, excepciones no manejadas), envía una señal de salida.
# Un proceso también puede morir enviando explícitamente una señal de salida:
spawn_link(fn -> exit(1) end)       #=> ** (EXIT from #PID<0.56.0>) evaluator process exited with reason: 1

# exit can also be “atrapada” using try/catch:
try do
  exit("I am exiting")
catch
  :exit, _ -> "not really"
end                                 #=> "not really"


"""
Los procesos normalmente se ejecutan bajo árboles de supervisión que son a su vez procesos que escuchan
las señales de salida de los procesos supervisados. Una vez que se recibe una señal de salida, la
estrategia de supervisión se pone en marcha y el proceso supervisado se reinicia.

Es precisamente este sistema de supervisión el que hace que construcciones como try/catch y try/rescue
sean tan poco comunes en Elixir. En lugar de rescatar un error, preferimos "fallar rápido" ya que el
árbol de supervisión garantizará que nuestra aplicación vuelva a un estado inicial conocido después del error.
"""

# ------------------------- after --------------------------------------------
# A veces es necesario asegurarse de que un recurso se limpie después de alguna acción que podría provocar un
# error. La construcción try/after te permite hacerlo. Por ejemplo, podemos abrir un archivo y utilizar una
# cláusula after para cerrarlo, incluso si algo va mal:
{:ok, file} = File.open("sample", [:utf8, :write])
try do
  IO.write(file, "olá")
  raise "oops, something went wrong"
after
  File.close(file)
end                             #=> ** (RuntimeError) oops, something went wrong

# Elixir permite omitir la línea try:
defmodule RunAfter do
  def without_even_trying do
    raise "oops"
  after
    IO.puts "cleaning up!"
  end
end
RunAfter.without_even_trying          #=> cleaning up!   ** (RuntimeError) oops
# Elixir envolverá automáticamente el cuerpo de la función en un try siempre que se especifique uno de los after, rescue o catch.

# --------------------- Else ------------------------------------------------------
x = 2
try do
  1 / x
rescue
  ArithmeticError ->
    :infinity
else
  y when y < 1 and y > -1 ->
    :small
  _ ->
    :large
end                                 #=> :small

# ---------------------- Variables scope ----------------------------------------------
"""
Al igual que con case, cond, if y otras construcciones en Elixir, las variables definidas dentro de
los bloques try/catch/rescue/after no se filtran al contexto externo.

Además, las variables definidas en el bloque do de try tampoco están disponibles dentro de rescue/after/else.
Esto se debe a que el bloque try puede fallar en cualquier momento y por lo tanto las variables pueden no
haber sido vinculadas en primer lugar.
"""
