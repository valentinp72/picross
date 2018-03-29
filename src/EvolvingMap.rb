require_relative 'Map'

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

	INCREMENT_RATIO = 5

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

		@totalLines    = lines
		@totalColumns  = columns
		@totalSolution = solutionGrid.clone

		@currentLines    = 5
		@currentColumns  = 5
		@currentSolution = solutionGrid.limit(@currentLines, @currentColumns)
		
		super(name, timeToDo, difficulty, @currentLines, @currentColumns, @currentSolution)
#	@clmSolution = computeColumnSolution(@solution)
#		@lneSolution = computeLineSolution(@solution)
	end

	def EvolvingMap.new_from_map(map)
		return EvolvingMap.new(map.name, map.timeToDo, map.difficulty, map.lneSolution.length, map.clmSolution.length, map.solution)
	end

	def evolve()
		self.increment(INCREMENT_RATIO)
		@currentSolution = @totalSolution.limit(@currentLines, @currentColumns)
		@clmSolution = computeColumnSolution(@currentSolution)
		@lneSolution = computeLineSolution(@currentSolution)
		
		@hypotheses = Hypotheses.new(@currentLines, @currentColumns)
	end

	def increment(ratio)
		@currentLines   = [@currentLines   + ratio, @totalLines].min
		@currentColumns = [@currentColumns + ratio, @totalColumns].min
	end

	def check()
		if super then
			return true if @currentLines == @totalLines && @currentColumns == @totalLines
			self.evolve
		end
		return false
	end

	def marshal_dump
		current = [@currentLines, @currentColumns, @currentSolution]
		total   = [@totalLines, @totalColumns, @totalSolution]
		return [super(), current, total]
	end

	def marshal_load(array)
		super(array[0])
		@currentLines, @currentColumns, @currentSolution = array[1]
		@totalLines, @totalColumns, @totalSolution       = array[2]
		return self
	end

end
