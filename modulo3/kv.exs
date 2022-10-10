"""
para mantener la configuración de la aplicación, o si necesita analizar un archivo y mantenerlo en la memoria,
¿dónde lo almacenaría? Primeramente se podría decir que con procesos.
Podemos escribir procesos que se repiten infinitamente, mantienen el estado y envían y reciben mensajes.
Como ejemplo:
"""
# módulo que inicie nuevos procesos que funcionen como un almacén clave-valor en un archivo llamado kv.exs
defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end
"""
Para probar este modulo se debe correr kv.exs
Luego ejecutamos estos comandos:
iex> {:ok, pid} = KV.start_link()       #=> {:ok, #PID<0.62.0>}
iex> send(pid, {:get, :hello, self()})  #=> {:get, :hello, #PID<0.41.0>}
iex> flush()                            #=> nil
                                        #=> :ok
"""
# Como al principio el mapa no tiene keys al enviar el mensaje :get retorna vacio(nil)
"""
Primero se enviara un mensaje :put y luego se manda un :get
iex> send(pid, {:put, :hello, :world})  #=> {:put, :hello, :world}
iex> send(pid, {:get, :hello, self()})  #=> {:get, :hello, #PID<0.41.0>}
iex> flush()                            #=> :world
                                        #=> :ok
"""
# Ahora si nos muestra un resultado al enviar el mensaje :get
# Cualquier proceso que conozca el pid anterior podrá enviarle mensajes y manipular el estado
"""
También es posible registrar el pid con register/2, dándole un nombre, y permitiendo que todos los que conozcan
el nombre puedan enviarle mensajes así:
iex> Process.register(pid, :kv)         #=> true
iex> send(:kv, {:get, :hello, self()})  #=> {:get, :hello, #PID<0.41.0>}
iex> flush()                            #=> :world
                                        #=> :ok
"""
# Este uso de procesos para mantener el estado y registro de normbes son muy comunes, sin embargo, casi siempre se
# no se implementaran estos patrones manualmente como en el anterior ejemplo, si no que se utilizaran abstraciones
# de Elixir como por ejemplo los agents:
"""
iex> {:ok, pid} = Agent.start_link(fn -> %{} end)                   #=> {:ok, #PID<0.72.0>}
iex> Process.register(pid, :ag)
iex> Agent.update(:ag, fn map -> Map.put(map, :hello, :world) end)  #=> :ok
iex> Agent.get(:ag, fn map -> Map.get(map, :hello) end)             #=> :world
"""
