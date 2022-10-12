"""
la sintaxis de Elixir permite a los desarrolladores omitir los delimitadores en algunas ocasiones
para hacer el código más legible. Por ejemplo se aprendio que los parentesis son opcionales y que
los bloques do-end son equivalentes a las listas de palabras clave.

Estas comodidades, que aquí llamamos "sintaxis opcional", permiten que el núcleo de la sintaxis del
lenguaje sea pequeño, sin sacrificar la legibilidad y la expresividad de su código. En este breve capítulo,
repasaremos las cuatro reglas que proporciona el lenguaje, utilizando un breve fragmento como campo de juego.
"""
# ----------------- Walk-through --------------------------------
if variable? do
  Call.this()
else
  Call.that()
end
# Ahora vamos a eliminar las comodidades una por una:

# 1. do-end block es una equivalencia a palabras clave.
if variable?, do: Call.this(), else: Call.that()

# 2. Las listas de palabras clave como último argumento no requieren corchetes.
if variable?, [do: Call.this(), else: Call.that()]

# 3. Las listas de palabras clave son las mismas que las listas de tuplas de dos elementos.
if variable?, [{:do, Call.this()}, {:else, Call.that()}]

# 4. Finalmente, los paréntesis son opcionales
if(variable?, [{:do, Call.this()}, {:else, Call.that()}])

"""
Si hay preocupación de cuándo aplicar esas reglas, hay que tener en cuenta que esas preocupaciones las maneja el
formateador de Elixir. Los desarrolladores de Elixir utilizan la tarea mix format para formatear nuestras bases
de código de acuerdo con un conjunto de reglas bien definidas por el equipo de Elixir
y la comunidad.
"""
