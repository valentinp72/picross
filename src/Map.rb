require_relative 'Hypotheses'
require_relative 'Statistics'
require_relative 'StatisticsArray'

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

	# Exception when the map to load does not exists.
	class MapNotFoundException < StandardError; end
	# Exception when the map cannot be load by Marshal (not a marshal file?).
	class CorruptedMapException < StandardError; end

	# The hypotheses stack used to allow the player to do hypotheses about the solution
	attr_accessor :hypotheses

	# The solution (a Grid) of the map
	attr_reader :solution

	# The name of the Map
	attr_reader :name

	# The estimated difficulty of the map
	attr_reader :difficulty

	# The numbers representing the columns solution (An array of arrays)
	attr_reader :clmSolution

	# The numbers representing the lines solution (An array of arrays)
	attr_reader :lneSolution

	# The User Statistic about this Map
	attr_reader :statistics

	# +timeToDo+ - The estimated time to resolve the game

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
		@name        = name
		@timeToDo    = timeToDo
		@difficulty  = difficulty
		@hypotheses  = Hypotheses.new(lines, columns)
		@solution    = solutionGrid
		@clmSolution = computeColumnSolution(@solution)
		@lneSolution = computeLineSolution(@solution)
		@currentStat = Statistic.new
		@allStat     = StatisticsArray.new
	end

	##
	# Load the file map to a new Map object.
	# * *Arguments* :
	#   - +fileName+ -> the map to load
	# * *Returns* :
	#   - the Map object corresponding to the object to load
	# * *Raises* :
	#   - +MapNotFoundException+  -> if the file does not exists
	#   - +CorruptedMapException+ -> if the file is corrupted to Marshal (not a Marshal file?)
	def Map.load(fileName)
		raise MapNotFoundException unless File.exists?(fileName)
		begin
			return Marshal.load(File.read(fileName))
		rescue
			raise CorruptedMapException
		end
	end

	##
	# Save the Map object to the given file name.
	# * *Arguments* :
	#   - +fileName+ -> the output file
	# * *Returns* :
	#   - the object itself
	def save(fileName)
		File.open(fileName, 'w') { |f| f.write(Marshal.dump(self)) }
		return self
	end

	##
	# Resets the stack of hypotheses to a blank one
	# * *Returns* :
	#   - the object itself
	def reset()
		@statistics.reset
		@hypotheses = Hypotheses.new(@solution.lines, @solution.columns)
		return self
	end

	##
	# Rotate the state of the cell on the higher hypothesis
	# at given coordinates.
	# (CELL_WHITE -> CELL_BLACK -> CELL_CROSSED -> CELL_WHITE ... )
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotateGTK_DEBUG=interactive
	#   - +column+ -> the column of the cell to rotate
	# * *Returns* :
	#   - the updated cell
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def rotateStateAt(line, column)
		hypothesis = @hypotheses.getWorkingHypothesis()
		cell = hypothesis.grid.getCellPosition(line, column)
		cell.stateRotate()
		cell.hypothesis = hypothesis
		@statistics.click()
		return self
	end

	##
	# Convert the solution grid to columns numbers
	# that help player to solve the game.
	# * *Arguments* :
	#   - +solutionGrid+ -> the solution grid
	# * *Returns* :
	#   - the array containing the numbers composing the columns
	def computeColumnSolution(solutionGrid)
		columnSolution = Array.new(solutionGrid.columns) { Array.new() }
		return computeGenericSolution(columnSolution, :each_column_with_index, solutionGrid)
	end


	##
	# Convert the solution grid to lines numbers
	# that help player to solve the game.
	# * *Arguments* :
	#   - +solutionGrid+ -> the solution grid
	# * *Returns* :
	#   - the array containing the numbers composing the lines
	def computeLineSolution(solutionGrid)
		lineSolution = Array.new(solutionGrid.lines) { Array.new() }
		return computeGenericSolution(lineSolution, :each_line_with_index, solutionGrid)
	end

	##
	# Convert the solutionGrid into an array of numbers (in solutionArray), according
	# to the loopType method givent.
	# * *Arguments* :
	#   - +solutionArray+ -> the array to put the solution in
	#   - +loopType+      -> a method name that allow looping solutionGrid, and getting the element and the index. Recommendend:
	#     - +:each_column_with_index+
	#     - +:each_line_with_index+
	#   - +solutionGrid+  -> the grid to computize the numbers
	# * *Returns* :
	#   - the solutionArray array of arrays of numbers
	def computeGenericSolution(solutionArray, loopType, solutionGrid)
		solutionGrid.send(loopType) do |columnOrLine, i|
			size = 0

			columnOrLine.each do |cell|
				if cell.state == Cell::CELL_BLACK then
					size += 1
				elsif size != 0 then
					solutionArray[i].push(size)
					size = 0
				end
			end
			if size != 0 then
				solutionArray[i].push(size)
				size = 0
			end
		end
		return solutionArray
	end

	def help(helpType)

	end

	def check()
		nb = @hypotheses.getWorkingHypothesis.grid.numberCell(Cell::CELL_BLACK)
		if nb == @solution.numberCell(Cell::CELL_BLACK) then
			if @solution.compare(@hypotheses.getWorkingHypothesis.grid) then
				return true

			end
		end
		return false
	end

	##
	# Retuns the map to a string, for debug only
	# * *Returns* :
	#   - the map into a String object
	def to_s()
		res  = "Printing Map -#{self.object_id}-\n\t"
		res += " - Name            : #{@name}\n\t"
		res += " - Difficulty      : #{@difficulty}\n\t"
		res += " - Time to do      : #{@timeToDo}\n\t"
		res += " - Hypotheses      : \n#{@hypotheses}\n\t"
		res += " - Solution        : \n#{@solution}\n\t"
		res += " - Columns solution: #{@clmSolution}\n\t"
		res += " - Lines solution  : #{@lneSolution}\n"
		res += " - Statistics      : #{@statistics}\n"
		return res
	end

	##
	# Convert the map to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the map converted to an array
	def marshal_dump()
		return [@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution, @currentStat, @allStat]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a map object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the map object itself
	def marshal_load(array)
		@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution, @currentStat, @allStat = array
		return self
	end

end
