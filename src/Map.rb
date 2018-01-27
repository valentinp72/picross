## 
# File          :: Map.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# This class represents a map in a *Picross*.  
# A map has an estimated time to be done, a difficulty, a stack of 
# hypotheses (Hypotheses object), and a solution grid.
# Every map can be saved to a file, and then loaded back, using Marshal.

class Map

	# +timeToDo+   - The estimated time to resolve the game
	# +difficulty+ - The estimated difficulty of the map
	# +hypotheses+ - The hypotheses stack used to allow the player to do hypotheses about the solution
	# +solution+   - The solution (a Grid) of the map

	##
	# Create a new map object
	# * *Arguments* :
	#   - +timeToDo+     -> estimated time to resolve the map
	#   - +difficulty+   -> estimated difficulty of the map
	#   - +lines+        -> number of lines of the map
	#   - +columns+      -> number of columns of the map
	#   - +solutionGrid+ -> the Grid representing the solution
	def initialize(timeToDo, difficulty, lines, columns, solutionGrid)
		@timeToDo   = timeToDo
		@difficulty = difficulty
		@hypotheses = Hypotheses.new(lines, columns)
		@solution   = solutionGrid
	end

	##
	#
	def Map.load(data)
		return Marshal.load(data)
	end

	##
	#
	def save()
		return Marshal.dump(self)
	end

	def reset()

	end

	def help(helpType)

	end

	##
	# Retuns the map to a string, for debug only
	# * *Returns* :
	#   - the map into a String object
	def to_s()
		return "Difficulty: #{@difficulty}, time to do: #{@timeToDo}, hypotheses: #{@hypotheses}, solution: #{@solution}"
	end

	##
	# Convert the map to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the map converted to an array
	def marshal_dump()
		return [@timeToDo, @difficulty, @hypotheses, @solution]
	end

	##
	# Update all the instances variables from the array given, 
	# allowing Marshal to load a map object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the map object itself
	def marshal_load(array)
		@timeToDo, @difficulty, @hypotheses, @solution = array
		return self
	end

end
