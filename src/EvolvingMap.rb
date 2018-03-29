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
# 

class EvolvingMap < Map

	START_SIZE      = 5
	INCREMENT_RATIO = 1

	attr_reader :currentLines
	attr_reader :currentColumns

	attr_reader :totalLines
	attr_reader :totalColumns

	##
	# Create a new map object
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
	# Resets the stack of hypotheses to a blank one
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

	def evolve()
		self.increment(INCREMENT_RATIO)
		@solution = @totalSolution.clone.limit(@currentLines, @currentColumns)
		@clmSolution = computeColumnSolution(@solution)
		@lneSolution = computeLineSolution(@solution)
		@hypotheses.validate(0)
		@hypotheses.workingHypothesis.grid.replaceAll(Cell::CELL_WHITE, Cell::CELL_CROSSED)
		@hypotheses.workingHypothesis.grid.grow(@currentLines, @currentColumns)
		@evolved = true
	end

	def increment(ratio)
		@currentLines   = [@currentLines   + ratio, @totalLines].min
		@currentColumns = [@currentColumns + ratio, @totalColumns].min
		puts @currentColumns, @currentLines
	end

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

	def evolving?
		return true
	end

	def evolved?
		if @evolved == true then
			@evolved = false
			return true
		end
		return false
	end

	def marshal_dump
		current = [@currentLines, @currentColumns]
		total   = [@totalLines, @totalColumns, @totalSolution]
		return [super(), current, total, @evolved]
	end

	def marshal_load(array)
		super(array[0])
		@currentLines, @currentColumns             = array[1]
		@totalLines, @totalColumns, @totalSolution = array[2]
		@evolved = array[3]
		return self
	end

end
