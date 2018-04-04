require_relative 'Map'
require_relative 'Cell'

##
# File          :: Learning.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 04/29/2018
# Last update   :: 04/29/2018
# Version       :: 0.1
#
# This class represents an Learning, a Map that grows when the user
# complet it.

class Learning < Map

	# The current number of displayed lines
	attr_reader :currentStage

	##
	# Create a new learning map
	# * *Arguments* :
	#   - +name+         -> a String representing the name of the map
	#   - +timeToDo+     -> estimated time to resolve the map
	#   - +difficulty+   -> estimated difficulty of the map
	#   - +lines+        -> number of lines of the map
	#   - +columns+      -> number of columns of the map
	#   - +solutionGrid+ -> the Grid representing the solution
	def initialize(name, timeToDo, difficulty, lines, columns, solutionGrid)
		@evolved = false
		@stage   = Array.new()
		@currentStage = 0

		super(name, timeToDo, difficulty, @currentLines, @currentColumns, solution)
	end

	##
	# Create a new learning map from a normal Map.
	# * *Arguments* :
	#   - +map+ -> the Map to create an learning map from
	# * *Returns* :
	#   - a freshly created Learning
	def Learning.new_from_map(map)
		return Learning.new(
				map.name,
				map.timeToDo,
				map.difficulty,
				map.lneSolution.length,
				map.clmSolution.length,
				map.solution
		)
	end

	##
	# Reset the learning map
	# * *Returns* :
	#   - the object itself
	def reset()
		@evolved = true
		super()
		return self
	end

	##
	# Evolve the map (make it grow) by the INCREMENT_RATIO value on the
	# width and the height.
	# * *Returns* :
	#   - the object itself
	def nextStage()
		@currentStage += 1
		@evolved = true
		return self
	end


	##
	# Check if the map is finished. If it's finished but can still evolve,
	# then it grow.
	# * *Returns* :
	#   - the object itself
	def check()
		if self.shouldFinish? then
			self.finish
			return true
		else
			self.nextStage
			return false
		end
	end

	##
	# As an Learning is learning, this returns true.
	# * *Returns* :
	#   - true
	def learning?
		return true
	end

	##
	# Tell if the map has evolved since the last time this method
	# was called.
	# * *Returns* :
	#   - true if the map has evolved since the last it was called
	def evolved?
		if @evolved == true then
			@evolved = false
			return true
		end
		return false
	end

	##
	# Dump the map into an array
	# * *Returns* :
	#   - an Array containing the Map
	def marshal_dump
		return [super(), @stage, @currentStage, @evolved]
	end

	##
	# Load the array (got by marshal_dump) into the current object
	# * *Returns* :
	#   - the object itself
	def marshal_load(array)
		super(array[0])
		@stage        = array[1]
		@currentStage = array[2]
		@evolved      = array[3]
		return self
	end

end
