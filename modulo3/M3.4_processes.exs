# ------------ Processes --------------------------------------------------------------------------
# ------------ spawn ---------------------------------------------------------------------------------
# El mecanismo básico para generar nuevos procesos es la función spawn/1 autoimportada
spawn(fn -> 1 + 2 end)    #=> PID<0.43.0> //toma una función que ejecutará en otro proceso
"""
Observe que devuelve un PID (identificador de proceso). En este punto, el proceso que ha
generado está probablemente muerto. El proceso generado ejecutará la función dada y saldrá después de
que la función haya terminado
"""
pid = spawn(fn -> 1 + 2 end)
Process.alive?(pid)           #=> false
# Se puede recuperar el PID del proceso actual
self()                        #=> PID<0.41.0> //ese código puede ser diferente en cada proceso
Process.alive?(self())        #=> true

# ------------ send and receive ------------------------------------------------------------------------
# We can send messages to a process with send/2 and receive them with receive/1:
send(self(), {:hello, "world"})
receive do
    {:hello, msg} -> msg                  #=> world
    {:world, _msg} -> "won't match"
end
"""
Cuando se envía un mensaje a un proceso, el mensaje se almacena en el buzón del proceso. El bloque receive/1
recorre el buzón del proceso actual buscando un mensaje que coincida con alguno de los patrones dados.
El proceso que envía el mensaje no se bloquea en send/2, pone el mensaje en el buzón del destinatario y continúa.
En particular, un proceso puede enviarse mensajes a sí mismo.
Si no hay ningún mensaje en el buzón que coincida con alguno de los patrones, el proceso actual esperará hasta
que llegue un mensaje que coincida. También se puede especificar un tiempo de espera
"""
receive do
{:hello, msg}  -> msg
after
  1_000 -> "nothing after 1s"
end

parent = self()                                   #=> PID<0.41.0>
spawn(fn -> send(parent, {:hello, self()}) end)   #=> #PID<0.48.0>
receive do
  {:hello, pid} -> "Got hello from #{inspect pid}"#=> "Got hello from #PID<0.48.0>"
end

# En el shell, se puede encontrar el ayudante flush/0 bastante útil. Este limpia e
# imprime todos los mensajes en el buzón
send(self(), :hello)                    #=> :hello
#flush()                                 #=> :hello
                                        #=> :ok

# ------------- Links -------------------------------------------------------------------------------------
"""
La mayoría de las veces que generamos procesos en Elixir, los generamos como procesos enlazados. Antes de
mostrar un ejemplo con spawn_link/1, veamos qué sucede cuando un proceso iniciado con spawn/1 falla
"""
# spawn(fn -> raise "oops" end) #=> [error] Process #PID<0.58.00> raised an exception

"""
Simplemente registró un error pero el proceso padre sigue funcionando. Eso es porque los procesos están
aislados. Si queremos que el fallo en un proceso se propague a otro, debemos enlazarlos. Esto se puede
hacer con spawn_link/1
"""
"""
self()         #=> PID<0.41.0>
spawn_link(fn -> raise "oops" end) #=> (RuntimeError) oops
#** (EXIT from #PID<0.41.0>) evaluator process exited with reason: an exception was raised:
"""

# ---------------- Tasks -----------------------------------------------------------------------------
#Task.start(fn -> raise "oops" end) #=> (RuntimeError) oops
"""
En lugar de spawn/1 y spawn_link/1, utilizamos Task.start/1 y Task.start_link/1 que devuelven {:ok, pid}
en lugar de sólo el PID. Esto es lo que permite utilizar las tareas en los árboles de supervisión. Además,
Task proporciona funciones de conveniencia, como Task.async/1 y Task.await/1, y funcionalidades para facilitar la distribución.
"""

# ------------------ State ---------------------------------------------------------------------------
# El ejemplo de este tipo de estado se hace en el archivo kv.exs
