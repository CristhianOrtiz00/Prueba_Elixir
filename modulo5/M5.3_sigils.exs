"""
Uno de los objetivos de Elixir es la extensibilidad: los desarrolladores deben poder ampliar el lenguaje
para adaptarlo a cualquier ámbito concreto. Elixir pretende hacerse extensible para que los desarrolladores, las
empresas y las comunidades puedan ampliar el lenguaje a sus dominios relevantes.

En este capítulo, vamos a explorar los sigils, que son uno de los mecanismos proporcionados por el lenguaje
para trabajar con representaciones textuales. Los sigils comienzan con el carácter tilde (~), al que sigue
una letra (que identifica el sigil) y luego un delimitador; opcionalmente, se pueden añadir modificadores
después del delimitador final.
"""

# ----------------- Regular expressions -----------------------------------------------
# El sigil más común en Elixir es ~r, que se utiliza para crear expresiones regulares:
# Una expresión regular que coincide con cadenas que contienen "foo" o "bar"
regex = ~r/foo|bar/
"foo" =~ regex                #=> true
"bat" =~ regex                #=> false

# Elixir proporciona expresiones regulares (regexes) tal y como las implementa la biblioteca PCRE.
# Las regexes también admiten modificadores. Por ejemplo, el modificador i hace que una expresión regular
# no distinga entre mayúsculas y minúsculas
"HELLO" =~ ~r/hello/          #=> false
"HELLO" =~ ~r/hello/i         #=> true

# Hasta ahora, todos los ejemplos han utilizado / para delimitar una expresión regular. Sin embargo, los
# sigilos soportan 8 delimitadores diferentes:
~r/hello/
~r|hello|
~r"hello"
~r'hello'
~r(hello)
~r[hello]
~r{hello}
~r<hello>

# ------------------- strings ----------------------------------------------------------------------------------
# La sigla ~s se utiliza para generar cadenas, como las comillas dobles. La sigla ~s es útil cuando una cadena
# contiene comillas dobles:
~s(this is a string with "double" quotes, not 'single' ones)  #=> "this is a string with \"double\" quotes, not 'single' ones"

# -------------------- Char lists --------------------------------------------------------------------------------
# El sigil ~c es útil para generar listas de caracteres que contengan comillas simples:
~c(this is a char list containing 'single quotes')    #=> 'this is a char list containing \'single quotes\''

# --------------------- Word lists --------------------------------------------------------------------------------
# El sigilo ~w se utiliza para generar listas de palabras (las palabras son simplemente cadenas regulares).
# Dentro del sigilo ~w, las palabras están separadas por espacios en blanco.
~w(foo bar bat)             #=> ["foo", "bar", "bat"]

# El sigilo ~w también acepta los modificadores c, s y a (para listas char, cadenas y átomos, respectivamente),
# que especifican el tipo de datos de los elementos de la lista resultante:
~w(foo bar bat)a             #=> [:foo, :bar, :bat]

# -------------------- Interpolation and escaping in string sigils ---------------------------------------------
# Elixir admite algunas variantes de sigil para tratar los caracteres de escape y la interpolación. En particular,
# los sigils de letras mayúsculas no realizan la interpolación ni el escape.

# Por ejemplo, aunque tanto ~s como ~S devolverán cadenas, el primero permite códigos de escape e interpolación
# mientras que el segundo no
~s(String with escape codes \x26 #{"inter" <> "polation"}) #=> "String with escape codes & interpolation"
~S(String without escape codes \x26 without #{interpolation})  #=> "String without escape codes \\x26 without \#{interpolation}"

# Los siguientes códigos de escape pueden utilizarse en cadenas y listas de caracteres:

#\\ – single backslash
#\a – bell/alert
#\b – backspace
#\d - delete
#\e - escape
#\f - form feed
#\n – newline
#\r – carriage return
#\s – space
#\t – tab
#\v – vertical tab
#\0 - null byte
#\xDD - represents a single byte in hexadecimal (such as \x13)
#\uDDDD and \u{D...} - represents a Unicode codepoint in hexadecimal (such as \u{1F600})


# Los Sigils también admiten heredocs, es decir, tres comillas dobles o simples como separadores:
~s"""
this is
a heredoc string
"""

# --------------------- Calendar sigils ----------------------------------------------------------------------
# --------- Date -------------------------------------
# Una estructura %Date{} contiene los campos año, mes, día y calendario. Puedes crear una usando el sigilo ~D:
d = ~D[2019-10-31]
d.day                             #=> 31

# --------- Time -------------------------------------
# La estructura %Time{} contiene los campos hora, minuto, segundo, microsegundo y calendario. Puedes
# crear una usando el sigilo ~T:
t = ~T[23:00:07.0]
t.second                          #=> 7

# --------- NaiveDateTime -------------------------------------
# La estructura %NaiveDateTime{} contiene campos tanto de Fecha como de Hora. Puedes crear una usando el sigilo ~N:
~N[2019-10-31 23:00:07]

# --------- NaiveDateTime -------------------------------------
dt = ~U[2019-10-31 19:59:03Z]
%DateTime{minute: minute, time_zone: time_zone} = dt    #=> ~U[2019-10-31 19:59:03Z]
minute                                                  #=> 59
time_zone                                               #=> "Etc/UTC"

# --------- NaiveDateTime -------------------------------------
# Como se insinuó al principio de este capítulo, los sigils en Elixir son extensibles. De hecho, usar el
# sigil ~r/foo/i es equivalente a llamar a sigil_r con un binario y una lista char como argumento:
sigil_r(<<"foo">>, 'i')         #=> ~r"foo"i

#h sigil_r         #=>//documentación del sigil

# También podemos proporcionar nuestros propios sigilos implementando funciones que sigan el patrón
# sigil_{character}. Por ejemplo, implementemos el sigil ~i que devuelve un entero (con el modificador opcional
# n para hacerlo negativo):
defmodule MySigils do
  def sigil_i(string, []), do: String.to_integer(string)
  def sigil_i(string, [?n]), do: -String.to_integer(string)
end

import MySigils
~i(13)                    #=> 13
~i(42)n                   #=> -42
