require_relative 'Hypotheses'
require_relative 'Statistic'
require_relative 'StatisticsArray'

require_relative 'PerformanceDebugger'

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

	# The User current statistic about this Map
	attr_reader :currentStat

	# The user current statistic about this Map
	attr_reader :allStat

	# The estimated time to resolve the game
	attr_reader :timeToDo
	attr_writer :timeToDo

	# The last correct state of the map before an error
	attr_reader :correctSaved

	# Free help given for this map?
	attr_accessor :givenHelp

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
		@name         = name                             # name of the map
		@timeToDo     = timeToDo                         # estimated time
		@difficulty   = difficulty                       # difficulty
		@hypotheses   = Hypotheses.new(lines, columns)   # stack of hypothesis
		@solution     = solutionGrid                     # solution (Grid)
		@clmSolution  = computeColumnSolution(@solution) # Array of Array (top)
		@lneSolution  = computeLineSolution(@solution)   # Array of array (left)
		@currentStat  = Statistic.new                    # curent user stat
		@allStat      = StatisticsArray.new              # all user stats
		@correctSaved = self.saveCorrectMap              # a copy of the map the last
		@givenHelp    = false                            # Free help given?
		                                                 # time it was correct
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
		@currentStat = Statistic.new
		@hypotheses = Hypotheses.new(@solution.lines, @solution.columns)
		return self
	end

	##
	# Returns the current grid of the Map
	# * *Returns* :
	#   - a Grid
	def grid
		return @hypotheses.workingHypothesis.grid
	end

	##
	# Saves this map as a correct map
	# * *Returns* :
	#   - the object itself
	def saveCorrectMap
		# PerformanceDebugger.showTime do
			# never ever ever ever ever forget to put that
			# if not present, this will double the size of the save at each save
			@correctSaved = nil

			@correctSaved = Marshal.load(Marshal.dump(self))
			@correctSaved.currentStat.time.pause
		# end
		return self
	end

	##
	# Rollback the map to the correct saved one
	# * *Returns* :
	#   - the object itself
	def rollbackCorrect
		@hypotheses  = @correctSaved.hypotheses
		@currentStat = @correctSaved.currentStat
		self.saveCorrectMap
	end

	##
	# Retrieve the cell to make it rotate, we increment the click
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotate
	#   - +column+ -> the column of the cell to rotate
	# * *Returns* :
	#   - the updated cell
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def retrieveForRotateAt(line, column)
		hypothesis = @hypotheses.getWorkingHypothesis()
		cell = hypothesis.grid.getCellPosition(line, column)
		cell.hypothesis = hypothesis
		currentStat.click()
		return cell
	end

	##
	# Rotate the state of the cell on the higher hypothesis
	# at given coordinates.
	# (CELL_WHITE -> CELL_BLACK -> CELL_WHITE ... )
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotate
	#   - +column+ -> the column of the cell to rotate
	# * *Returns* :
	#   - the updated cell
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def rotateStateAt(line, column)
		retrieveForRotateAt(line,column).stateRotate()
	end

	##
	# Rotate the state of the cell on the higher hypothesis
	# at given coordinates.
	# (CELL_WHITE -> CELL_CROSSED -> CELL_WHITE ... )
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotate
	#   - +column+ -> the column of the cell to rotate
	# * *Returns* :
	#   - the updated cell
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def rotateStateInvertAt(line, column)
		retrieveForRotateAt(line,column).stateInvertCross()
	end

	##
	# Rotate to the wanted state of the cell on the higher hypothesis
	# at given coordinates.
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotate
	#   - +column+ -> the column of the cell to rotate
	#   - +state+  -> the wanted state
	# * *Returns* :
	#   - the updated cell
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def rotateToStateAt(line, column, state)
		hypothesis = @hypotheses.getWorkingHypothesis()
		cell = hypothesis.grid.getCellPosition(line, column)
		if(cell.state != state) then
			cell.state = state
			cell.hypothesis = hypothesis
			currentStat.click()
		end
		return cell
	end

	##
	# Return an array containing the line solution the user has made in his grid.
	# This can be interpreted as a lineSolution.
	# * *Returns* :
	#   - an Array of Array of the numbers the user has put in his lines
	def alreadyDoneLineSolution
		return computeLineSolution(@hypotheses.workingHypothesis.grid)
	end

	##
	# Return an array containing the column solution the user has made in his grid.
	# This can be interpreted as a columnSolution.
	# * *Returns* :
	#   - an Array of Array of the numbers the user has put in his columns
	def alreadyDoneColumnSolution
		return computeColumnSolution(@hypotheses.workingHypothesis.grid)
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

	##
	# Tells if the map has an error comparing to the solution grid.
	# * *Returns* :
	#   - true if the user has made an error, false otherwise
	def hasError?
		self.grid.each_cell_with_index do |cell, j, i|
			sol = @solution.cellPosition(j, i).state
			if cell.state == Cell::CELL_BLACK && sol != Cell::CELL_BLACK then
				return true
			elsif cell.state == Cell::CELL_CROSSED && sol == Cell::CELL_BLACK then
				return true
			end
		end
		return false
	end

	##
	# Tells weather or not the map is finished.
	# If the map does not contains an error, this also save itself.
	# * *Returns* :
	#   - true or false if the game should be finished
	def shouldFinish?
		if not hasError? then
			self.saveCorrectMap
			if !@currentStat.isFinished then
				if @solution.compare(grid) then
					return true
				end
			end
		end
		return false
	end

	##
	# Tells the map to be finished.
	# That's includes :
	#   - validating all the hypotheses
	#   - end the timer
	#   - store the current stats
	# * *Returns* :
	#   - the object itself
	def finish
		@currentStat.finish(@timeToDo)
		@allStat.addStatistic(@currentStat)
		@hypotheses.validate(0)
		@hypotheses.getWorkingHypothesis.grid.finish
		return self
	end

	##
	# Check if the game should be finished, if so, finish the game.
	# * *Returns* :
	#   - true if the game is now finished, false it the game should not be
	def check()
		if self.shouldFinish? then
			self.finish
			return true
		end
		return false
	end

	##
	# Returns false, this map is not evolving (see EvolvingMap)
	# * *Returns* :
	#   - false
	def evolving?
		return false
	end

	##
	# Returns false, this map is not learning (see LearningMap)
	# * *Returns* :
	#   - false
	def learning?
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
		res += " - Given Help      : #{@givenHelp}\n"
		res += " - Current Stat    : #{@currentStat}\n"
		res += " - All Stats       : #{@allStat}\n"
		return res
	end

	##
	# Convert the map to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the map converted to an array
	def marshal_dump()
		return [@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution, @currentStat, @allStat, @correctSaved, @givenHelp]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a map object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the map object itself
	def marshal_load(array)
		@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution, @currentStat, @allStat, @correctSaved, @givenHelp = array
		return self
	end

end
