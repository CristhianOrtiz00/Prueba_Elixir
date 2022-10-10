"""
Para facilitar la reutilización del software, Elixir proporciona tres directivas (alias, require e import)
más una macro llamada use.
Las tres primeras se llaman directivas porque tienen alcance léxico, mientras que use es un punto de extensión
común que permite al módulo usado inyectar código
resumen a continuación:

# Alias del módulo para que pueda ser llamado como Bar en lugar de Foo.Bar
alias Foo.Bar, as: Bar

# Requerir el módulo para poder utilizar sus macros
require Foo

# Importar funciones de Foo para que puedan ser llamadas sin el prefijo `Foo.`.
importar Foo

# Invoca el código personalizado definido en Foo como punto de extensión
use Foo
"""

# --------------------- alias -------------------------------------------------------------------------------
# Permite establecer alias para cualquier nombre de módulo dado
# si no se coloca una opción al :as se estable el alias por defecto a la ultima parte del nombre
alias Math.List, as: List
alias Math.List           #=> ambas equivales a lo mismo

# Note: los alias tienen un alcance léxico, lo que le permite establecer alias dentro de funciones específicas

# --------------------- require -----------------------------------------------------------------------------
# Las macros se expanden en tiempo de compilación.
# Las funciones públicas en los módulos están disponibles a nivel global,
# pero para usar macros, debe optar por requerir el módulo en el que se definen
"""
iex> Integer.is_odd(3)
** (UndefinedFunctionError) function Integer.is_odd/1 is undefined or private. However, there is a macro with the same name and arity. Be sure to require Integer if you intend to invoke this macro
    (elixir) Integer.is_odd(3)
iex> require Integer      #=> Integer
iex> Integer.is_odd(3)    #=> true
"""
# Integer.is_odd/1 está definida como una macro para que pueda ser utilizada como guardia. Por eso necesitamos require Integer
# require también tiene un alcance léxico

# ----------------------- import -------------------------------------------------------------------------------
# Funciona de la misma manera, cambia en la manera de importar cuando solo se quiere una función.
# Tamibien tiene un alcance léxico.
# Sólo se puede importar funciones públicas.
defmodule Math do
    def some_function do
      import List, only: [duplicate: 2]
      duplicate(:ok, 10)
    end
end
# Note: las importaciones están generalmente desaconsejadas en el lenguaje, es preferible usar el alias.
