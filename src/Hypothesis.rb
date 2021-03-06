## 
# File          :: Hypothesis.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# This class represent an hypothesis. 
# An hypothesis is a stack of grids, where the top one is the current game.  
# Each hypothesis have a color, so the game can display the hypothesis differently.

class Hypothesis

	SOLUTION_HYPOTHESIS = "solution_hypothesis"

	# The grid of the hypothesis
	attr_reader :grid
	attr_writer :grid

	# The id (0 to 4) of the hypothesis
	attr_reader :id
	attr_writer :id

	##
	# Creation of an hypothesis.  
	# * *Arguments* :
	#   - *grid* -> the grid of hypothesis to create
	def initialize(grid, id)
		@grid  = grid
		@id    = id
	end

	##
	# Converts the hypothesis to a String, for printing
	# * *Returns* :
	#   - the hypothesis into a String
	def to_s()
		return "ID: #{@id}\n" + @grid.to_s
	end

	##
	# Convert the hypothesis to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the hypothesis converted to an array
	def marshal_dump()
		return [@grid, @id]
	end

	##
	# Update all the instances variables from the array given, 
	# allowing Marshal to load an hypothesis.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the hypothesis itself
	def marshal_load(array)
		@grid, @id = array
		return self
	end

end
