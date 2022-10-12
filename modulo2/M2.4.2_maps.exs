# ------ Maps ->
map = %{:a => 1, 2 => :b}		#//%{2 => :b, :a => 1}
IO.puts (map[:a])					#//1
IO.puts (map[2])					#//b
IO.puts (map[:c])					#//nil

# Diferencias entre Keyword list and maps:
# Los mapas permiten cualquier valor como clave.
# Las claves de los mapas no siguen ningún orden.

# Cuando se utiliza un mapa en un patón, siempre conincidira en un subconjunto del valor dado
%{} = %{:a => 1, 2 => :b}			#//%{2 => :b, :a => 1} -> un mapa vacío coincide con todos los mapas
%{:a => a} = %{:a => 1, 2 => :b}
IO.puts a							#//1
#%{:c => c} = %{:a => 1, 2 => :b}	#//** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}

# Las variables se pueden utilizar al acceder, hacer coincidir y agregar claves de mapa
n = 1
map = %{n => :one}					#//%{1 => :one}
IO.puts map[n]						  #//one
%{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}	#//%{1 => :one, 2 => :two, 3 => :three}

# El módulo Map proporciona una API con funciones convenientes para manipular mapas:
IO.puts Map.get(%{:a => 1, 2 => :b}, :a)	#//1
Map.put(%{:a => 1, 2 => :b}, :c, 3)			  #//%{2 => :b, :a => 1, :c => 3}
Map.to_list(%{:a => 1, 2 => :b})			    #//[{2, :b}, {:a, 1}]

# Actualizar el valor de una clave
map = %{:a => 1, 2 => :b}			#//%{2 => :b, :a => 1}
%{map | 2 => "two"}					  #//%{2 => "two", :a => 1}
#%{map | :c => 3}					    #//(KeyError) key :c not found in: %{2 => :b, :a => 1}

# Cuando todas las claves de un mapa son átomos, puede usar la sintaxis de la palabra clave para mayor comodidad:
map = %{a: 1, b: 2}

# Sintaxis para acceder a las claves atómicas
map = %{:a => 1, 2 => :b}
IO.puts map.a						#//1
#map.c								  #//(KeyError)

# ------ Blocks and keywords
# las palabras clave se utilizan principalmente en el lenguaje para pasar valores opcionales
if true do
	"This will be seen"
else
	"This won't"
end
# Sucede que los bloques do no son más que una conveniencia de sintaxis sobre las palabras clave. Podemos reescribir lo anterior
if true, do: "This will be seen", else: "This won't"

# keywords lists que pueden convertirse en bloques:
# do, else, catch, rescue y after. Esas son todas las palabras clave utilizadas por las construcciones
# de flujo de control de Elixir. Ya hemos aprendido algunas de ellas y aprenderemos otras en el futuro.

# ------ Nested data structures(Estructuras de datos anidadas)
# Elixir proporciona comodidades para manipular estructuras de datos anidadas a través de las macros put_in/2, update_in/2 y otras
users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]
IO.puts users[:john].age			#//27 ->  De esta manera se accede a un dato en una estructura de datos anidadas
users = put_in users[:john].age, 31	#//-> usar esta misma sintaxis para actualizar el valor a 31

# La macro update_in/2 es similar, pero nos permite pasar una función que controla cómo cambia el valor.
users = update_in users[:mary].languages, fn languages -> List.delete(languages, "Clojure") end
