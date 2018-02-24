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

	def each_cell_with_index()
		self.each_line_with_index do |line, j|
			line.each_index do |i|
				yield @grid[j][i], j, i
			end
		end
		return self
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
		@grid.each_cell_with_index do |cell, line, column|
			if !cell.compare(grid[line][column]) then
				return false
			end
		end
		return true
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
