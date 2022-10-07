# ----------------- use -------------------------------------------------------------------
"""
La macro use se utiliza frecuentemente como punto de extensión. Esto significa que, cuando se utiliza un
módulo FooBar, se permite a ese módulo inyectar cualquier código en el módulo actual, como importarse a sí
mismo o a otros módulos, definir nuevas funciones, establecer el estado de un módulo, etc.
"""
# Ejemplo: para escribir pruebas utilizando el framework ExUnit, se debe utilizar el módulo ExUnit.Case
defmodule AssertionTest do
  ExUnit.start()  #//Se debe colocar en los archivos .exs.
  use ExUnit.Case, async: true

  test "always pass" do
    assert true
  end
end

"""
Algunos módulos (por ejemplo, ExUnit.Case, Supervisor y GenServer) utilizan este mecanismo para rellenar
su módulo con algún comportamiento básico, que su módulo pretende anular o completar.
"""
# Note: Dado que su uso permite la ejecución de cualquier código, no se puede conocer realmente los efectos
# secundarios del uso de un módulo sin leer su documentación. Por lo tanto, hay que utilizar esta función con
# cuidado y sólo si es estrictamente necesario. No utilices use donde un import o un alias servirían.

# --------------------- Understanding Aliases(Descripción de los alias) ---------------------------------------
# Un alias en Elixir es un identificador en mayúsculas (como String, Keyword, etc) que se convierte en un átomo
# durante la compilación. Por ejemplo:
is_atom(String)               #=> true
to_string(String)             #=> "Elixir.String"
:"Elixir.String" == String    #=> true //Al utilizar la alias/2, estamos cambiando el átomo al que se expande el alias

# Note: Los alias se expanden a átomos porque en la VM de Erlang los módulos siempre están representados por átomos.

# ------------------------- Module nesting(anidamiento de módulos) --------------------------------------------
defmodule Foo do
  defmodule Bar do
  end
end
# Se puede acceder al segundo como Bar dentro de Foo siempre que estén en el mismo ámbito léxico

# Si el módulo Bar se mueve fuera de la definición del módulo Foo, debe ser referenciado por su nombre
# completo (Foo.Bar) o debe establecerse un alias.

# Note: No es necesario definir el módulo Foo antes de poder definir el módulo Foo.Bar, ya que
# son efectivamente independientes.
defmodule Foo.Bar do
end

defmodule Foo do
  alias Foo.Bar
  # Can still access it as `Bar`
end

# El alias de un módulo anidado no incluye los módulos primarios en el ámbito
defmodule Foo do
  defmodule Bar do
    defmodule Baz do
    end
  end
end

alias Foo.Bar.Baz
# The module `Foo.Bar.Baz` is now available as `Baz`
# However, the module `Foo.Bar` is *not* available as `Bar`

# --------------------------------- Multi alias/import/require/use ------------------------------------
# Es posible poner un alias, importar, requerir o utilizar varios módulos a la vez. Esto es particularmente
# útil una vez que empezamos a anidar módulos, lo cual es muy común cuando se construyen aplicaciones Elixir.

# Ejemplo: imagina que tienes una aplicación en la que todos los módulos están anidados bajo MyApp, puedes ponerle un
# alias a los módulos MyApp.Foo, MyApp.Bar y MyApp.Baz a la vez de la siguiente manera
alias MyApp.{Foo, Bar, Baz}
