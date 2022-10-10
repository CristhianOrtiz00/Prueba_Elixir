# ----- Basic operators
# +, -, *, /
# div/2, rem/2
# ++, --


# ----- List manipulation
list = [1, 2, 3] ++ [4, 5, 6]	#//[1, 2, 3, 4, 5, 6]
list2 = [1, 2, 3] -- [2] 		#//[1, 3]
IO.puts hd list				#//1 -> Obtiene la cabeza de la lista
IO.puts tl(list)				#//[2, 3] -> Obtiene la cola de la lista
IO.puts list2					#//[1, 3]

# ----- string concatenation
IO.puts "foo" <> "bar"			#//"foobar"

# ----- Boolean operators
# or, and, not -> only use them when Booleans are expected (true, false)
true and true			#//true
false or is_atom(:example)	#//true
# 1 and true 			#//(BadBooleanError) expected a boolean on left-side of "and", got: 1

# ||, &&, ! -> can be used with any type of data
1 || true				  #//1
false || 11 			#//11
nil && 13 				#//nil
true && 17 				#//17
!true 					  #//false
!1 						    #//false
!nil 					    #//true

# ==, !=, ===, !==, <=, >=, <, > -> comparative operators
IO.puts 1 == 1.0				#//true
IO.puts 1 === 1.0				#//false -> is more strict when compararing integers and floats
