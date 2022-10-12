# ----- Loops through recursion
# Debido a la inmutabilidad, los bucles en Elixir se escriben de manera diferente a los lenguajes imperativos
# Los bucles se hacen de manera recursiva, hata que alcanza una condición que impide que la acción recursiva continue
defmodule Recursion do
  def print_multiple_times(msg, n) when n > 0 do
    IO.puts(msg)
    print_multiple_times(msg, n - 1)
  end

  def print_multiple_times(_msg, 0) do
    :ok
  end
end
Recursion.print_multiple_times("Hello!", 3)     # Hello!
                                                # Hello!
                                                # Hello!
                                                :ok

# Note: Si se pasa un argumento que no coincide con ninguna cláusula se lanza una exception FunctionClauseError
# en el ejemplo anterior un argumento que no coincide con ninguno podría ser -1
#Recursion.print_multiple_times "Hello!", -1    #=> (FunctionClauseError) no function clause matching in

# ------ Reduce and map algorithms
# sumar una lista de números
defmodule Math do
  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end
end
IO.puts Math.sum_list([1, 2, 3], 0)   #=> 6

# Note: El proceso de tomar una lista y reducirla a un valor se conoce como algoritmo de reducción y es fundamental
# en la programación funcional

# Duplicar los valores de una lista con la recursividad
defmodule Math2 do
  def double_each([head | tail]) do
    [head * 2 | double_each(tail)]
  end

  def double_each([]) do
    []
  end
end
IO.puts Math2.double_each([1, 2, 3])     #=> [2, 4, 6]

# Función para imprimir los datos de una lista
defmodule Listas do
  def imprimir_lista(msj, [head | tail]) do
    imprimir_lista(msj <> to_string(head) <> " ", tail)
  end

  def imprimir_lista(msj, []) do
    msj
  end
end
IO.puts Listas.imprimir_lista("", [1, 2, 3])

# El módulo Enum, ya proporciona muchas comodidades para trabajar con listas.
# Por ejemplo, los ejemplos anteriores podrían escribirse como:
Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end)    #=> 6
Enum.map([1, 2, 3], fn(x) -> x * 2 end)                 #=> [2, 4, 6]
