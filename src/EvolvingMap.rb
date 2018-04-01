require_relative 'Map'
require_relative 'Cell'

##
# File          :: EvolvingMap.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/29/2018
# Last update   :: 03/29/2018
# Version       :: 0.1
#
# This class represents an EvolvingMap, a Map that grows when the user
# complet it.

class EvolvingMap < Map

	# The start size (width and height) of the map
	START_SIZE      = 5

	# How many cells we grow in each dimmension?
	INCREMENT_RATIO = 5

	# The current number of displayed lines 
	attr_reader :currentLines

	# The current number of displayed columns 
	attr_reader :currentColumns

	# The total number of lines to display 
	attr_reader :totalLines
	# The total number of columns to display 
	attr_reader :totalColumns

	##
	# Create a new evolving map 
	# * *Arguments* :
	#   - +name+         -> a String representing the name of the map
	#   - +timeToDo+     -> estimated time to resolve the map
	#   - +difficulty+   -> estimated difficulty of the map
	#   - +lines+        -> number of lines of the map
	#   - +columns+      -> number of columns of the map
	#   - +solutionGrid+ -> the Grid representing the solution
	def initialize(name, timeToDo, difficulty, lines, columns, solutionGrid)
		@evolved       = false
		@totalLines    = lines
		@totalColumns  = columns
		@totalSolution = solutionGrid.clone

		@currentLines    = START_SIZE
		@currentColumns  = START_SIZE
		solution = solutionGrid.limit(@currentLines, @currentColumns)
		
		super(name, timeToDo, difficulty, @currentLines, @currentColumns, solution)
	end

	##
	# Create a new evolving map from a normal Map.
	# * *Arguments* :
	#   - +map+ -> the Map to create an evolving map from
	# * *Returns* :
	#   - a freshly created EvolvingMap
	def EvolvingMap.new_from_map(map)
		return EvolvingMap.new(
				map.name,
				map.timeToDo, 
				map.difficulty, 
				map.lneSolution.length, 
				map.clmSolution.length, 
				map.solution
		)
	end

	##
	# Reset the evolving map
	# * *Returns* :
	#   - the object itself
	def reset()
		@currentLines   = START_SIZE
		@currentColumns = START_SIZE
		@solution.limit(@currentLines, @currentColumns)
		@clmSolution = computeColumnSolution(@solution)
		@lneSolution = computeLineSolution(@solution)
		@evolved = true
		super()
		return self
	end

	##
	# Evolve the map (make it grow) by the INCREMENT_RATIO value on the
	# width and the height.
	# * *Returns* :
	#   - the object itself
	def evolve()
		self.increment(INCREMENT_RATIO)
		@solution = @totalSolution.clone.limit(@currentLines, @currentColumns)
		@clmSolution = computeColumnSolution(@solution)
		@lneSolution = computeLineSolution(@solution)
		@hypotheses.validate(0)
		@hypotheses.workingHypothesis.grid.replaceAll(Cell::CELL_WHITE, Cell::CELL_CROSSED)
		@hypotheses.workingHypothesis.grid.grow(@currentLines, @currentColumns)
		@evolved = true
		return self
	end

	##
	# Increment the map current lines and current columns by the given ration.
	# This prevent having a number lines/columns to display greater
	# than the total.
	# * *Arguments* :
	#   - +ratio+ -> the ratio to grow the map
	# * *Returns* :
	#   - the object itself
	def increment(ratio)
		@currentLines   = [@currentLines   + ratio, @totalLines].min
		@currentColumns = [@currentColumns + ratio, @totalColumns].min
		return self
	end

	##
	# Check if the map is finished. If it's finished but can still evolve, 
	# then it grow.
	# * *Returns* :
	#   - the object itself
	def check()
		if self.shouldFinish? then
			if @currentLines == @totalLines && @currentColumns == @totalLines then
				self.finish
				return true
			end
			self.evolve
		end
		return false
	end

	##
	# As an EvolvingMap is evolving, this returns true.
	# * *Returns* : 
	#   - true
	def evolving?
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
		current = [@currentLines, @currentColumns]
		total   = [@totalLines, @totalColumns, @totalSolution]
		return [super(), current, total, @evolved]
	end

	##
	# Load the array (got by marshal_dump) into the current object
	# * *Returns* :
	#   - the object itself
	def marshal_load(array)
		super(array[0])
		@currentLines, @currentColumns             = array[1]
		@totalLines, @totalColumns, @totalSolution = array[2]
		@evolved = array[3]
		return self
	end

end
