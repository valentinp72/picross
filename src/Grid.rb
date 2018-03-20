require_relative 'Cell'
require_relative 'Hypothesis'

##
# File          :: Grid.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# Represent a grid, composed of cells.

class Grid

	# The number of columns of the grid
	attr_reader :columns

	# The number of lines of the grid
	attr_reader :lines

	# The array of arrays that contains all the cells
	attr_reader :grid
	attr_writer :grid

	# Exception when the wanted cell is invalid.
	class InvalidCellPositionException < StandardError; end

	# Exception when searching a cell that is not present in the grid.
	class CellNotInGridException < StandardError; end

	##
	# Create a grid of size line x columns
	# * *Arguments* :
	#   - +lines+      -> an integer greater than 0
	#   - +columns+    -> an integer greater than 0
	#   - +hypothesis+ -> optional, the future hypothesis of all created cells,
	#     if no hypothesis, the grid is not created.
	def initialize(lines, columns, hypothesis=nil)
		@lines   = lines
		@columns = columns

		if hypothesis != nil then
			@grid = Array.new(lines) do |j|
				Array.new(columns) do |i|
					Cell.new(hypothesis, j, i)
				end
			end
		end
	end

	##
	# Return an exact copy of self (every cell is duplicated)
	# * *Returns* :
	#   - the cloned grid
	def clone()
		cLines   = @lines
		cColumns = @columns
		cGrid    = @grid.map { |line| line.map { |cell| cell.clone } } # we clone each cell

		# we cannot create a grid with already a grid, so we set it to nil,
		# and after that we update the actual grid
		newGrid  = Grid.new(cLines, cColumns, nil)
		newGrid.grid = cGrid
		return newGrid
	end

	##
	# Change all cells states to a random one
	# * *Returns* :
	#   - the grid itself
	def randomCells()
		@grid.each do |lines|
			lines.each do |cell|
				if rand(0..1) == 0 then
					cell.stateRotate
				end
			end
		end
		return self
	end

	def hypothesis=(newHypothesis)
		self.each_cell do |cell|
			cell.hypothesis = newHypothesis
		end
		return self
	end

	##
	# Returns true if the given position is a valid coordinate, false otherwise
	# * *Arguments* :
	#   - +line+ -> the line to check at
	#   - +column+ -> the column to check at
	# * *Returns* :
	#   - true if correct, false otherwise
	def validPosition?(line, column)
		return line < @lines && line >= 0 && column < @columns && column >= 0
	end

	##
	# Return the cell at given position
	# * *Arguments* :
	#   - +line+   -> the line of the wanted cell
	#   - +column+ -> the column of the wanted cell
	# * *Returns* :
	#   - the cell at (line, column)
	# * *Raises* :
	#   - +InvalidCellPositionException+ -> if given coordinates are invalid
	def getCellPosition(line, column)
		if not validPosition?(line, column)
			raise InvalidCellPositionException, "(#{line}, #{column}) not correct"
		end
		return @grid[line][column]
	end

	##
	# Calls the given block for every line in the Grid.
	# * *Yields* :
	#   - an Array of Cell of every lines in the Grid
	# * *Returns* :
	#   - the Grid itself
	def each_line()
		@grid.each do |line|
			yield line
		end
		return self
	end

	##
	# Calls the given block for every line in the Grid, with the indexes.
	# * *Yields* :
	#   - an Array of Cell of every lines in the Grid
	#   - the index of the array in the Grid
	# * *Returns* :
	#   - the Grid itself
	def each_line_with_index()
		@grid.each_index do |i|
			yield @grid[i], i
		end
		return self
	end

	##
	# Calls the given block for every column in the Grid.
	# * *Yields* :
	#   - an Array of Cell of every columns in the Grid
	# * *Returns* :
	#   - the Grid itself
	def each_column()
		@grid.transpose.each do |column|
			yield column
		end
		return self
	end

	##
	# Calls the given block for every column in the Grid, with the indexes.
	# * *Yields* :
	#   - an Array of Cell of every columns in the Grid
	#   - the index of the array in the Grid
	# * *Returns* :
	#   - the Grid itself
	def each_column_with_index()
		tmpGrid = @grid.transpose
		tmpGrid.each_index do |i|
			yield tmpGrid[i], i
		end
		return self
	end

	##
	# Calls the given block for every cell in the Grid, from
	# top left to bottom right.
	# * *Yields* :
	#   - a Cell for every cell in the Grid
	# * *Returns* :
	#   - the Grid itself
	def each_cell()
		self.each_line do |line|
			line.each do |cell|
				yield cell
			end
		end
		return self
	end

	##
	# Calls the given block for every cell in the Grid, from
	# top left to bottom right, including the indexes of each
	# Cell.
	# * *Yields* :
	#   - a Cell for every cell in the Grid
	#   - the line of the cell in the grid
	#   - the column of the cell in the grid
	# * *Returns* :
	#   - the Grid itsel
	def each_cell_with_index()
		self.each_line_with_index do |line, j|
			line.each_index do |i|
				yield @grid[j][i], j, i
			end
		end
		return self
	end

	##
	# Returns an array of Cells, representing the line that 
	# contains the cell line.
	# * *Arguments* :
	#   - +cell+ -> the cell to search it's line
	# * *Returns* :
	#   - an Array of Cell representing the line of the cell
	def lineContaining(cell)
		self.each_line do |line|
			return line if line.include?(cell)
		end
		raise CellNotInGridException.new("Cell #{cell} was not found the the grid")
	end

	##
	# Returns an array of Cells, representing the column that 
	# contains the cell line.
	# * *Arguments* :
	#   - +cell+ -> the cell to search it's column
	# * *Returns* :
	#   - an Array of Cell representing the column of the cell
	def columnContaining(cell)
		self.each_column do |column|
			return column if column.include?(cell)
		end
		raise CellNotInGridException.new("Cell #{cell} was not found the the grid")
	end

	##
	# Returns the total length of the column of the same cells colors as
	# the given cell.
	# * *Arguments* :
	#   - +cell+     -> the cell to look the state for
	# * *Returns* :
	#   - the total length
	def totalLengthVertical(cell)
		return totalLengthIntern(self.columnContaining(cell), cell)
	end

	##
	# Returns the total length of the line of the same cells colors as
	# the given cell.
	# * *Arguments* :
	#   - +cell+     -> the cell to look the state for
	# * *Returns* :
	#   - the total length
	def totalLengthHorizontal(cell)
		return totalLengthIntern(self.lineContaining(cell), cell)
	end
	##
	# Returns the total length of same state of the given cell in the given array.
	# Separated from totalLength() because we don't want a WET solution, but a DRY one.
	# * *Arguments* :
	#   - +array+ -> the array to search in
	#   - +cell+  -> the cell to search in the array
	# * *Returns* :
	#   - the length of the same cell states near the cell in the array
	def totalLengthIntern(array, cell)
		length    = 1 # the cell, not counted after that
		position  = array.index(cell)
		raise CellNotInGridException if position == nil
		
		# count the length after the cell in the array
		afterCell = array.drop(position + 1)
		length   += numberOfSameStates(afterCell, cell.state)

		# count the length before the cell in the array
		beforeCell = array[0..position]
		beforeCell.pop(1)
		length    += numberOfSameStates(beforeCell.reverse, cell.state)	

		return length
	end

	##
	# Count the number of the cells in the array that have the specific given state
	# * *Arguments* : 
	#   - +array+ -> the array to search in
	#   - +state+ -> the state the Cells must have inside the array to be counted
	# * *Returns* :
	#   - the number of cells that have the state +state+
	def numberOfSameStates(array, state)
		length = 0
		array.each do |cell|
			if cell.state == state then
				length += 1 # same state, we update the length
			else
				break       # different state, we stop here (efficacity)
			end
		end
		return length
	end

	##
	# Return the grid into a String, for debug printing
	# * *Returns* :
	#   - a String representing the grid
	def to_s()
		r = " "

		# print columns numbers
		0.upto(@columns - 1) do |i|
			r += i.to_s
		end
		r += "\n"

		# print each line
		@grid.each_index do |j|
			# add the line number
			r += j.to_s

			# print each cell
			@grid[j].each do |cell|
				r += cell.to_s
			end
			r += "\n"
		end

		return r
	end

	##
	# Compare the grid to the one given as parameter.
	# * *Returns* :
	#   - true if the grids are the same
	def compare(grid)
		each_cell_with_index do |cell, line, column|
			if !cell.compare(grid.grid[line][column]) then
				return false
			end
		end
		return true
	end

	##
	# Returns the number of cell that have the same state as the one given as parameter.
	# * *Returns* :
	#   - Numbers of cell having the same state
	def numberCell(state)
		i = 0
		each_cell_with_index do |cell, line, column|
			if(cell.state == state) then
				i += 1
			end
		end
		return i
	end

	##
	# Convert the grid to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the grid converted to an array
	def marshal_dump()
		return [@columns, @lines, @grid]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a grid.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the grid itself
	def marshal_load(array)
		@columns, @lines, @grid = array
		return self
	end

end
