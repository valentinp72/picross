require_relative 'Cell'

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
			@grid = Array.new(lines) { Array.new(columns) { Cell.new(hypothesis) } }
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
	# Return the cell at given position
	# * *Arguments* :
	#   - +line+   -> the line of the wanted cell
	#   - +column+ -> the column of the wanted cell
	# * *Returns* :
	#   - the cell at (line, column)
	# * *Raises* :
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def getCellPosition(line, column)
		if line >= @lines or line < 0 or column >= @columns or column < 0 then
			raise "InvalidCellPosition"
		end
		return @grid[line][column]
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
