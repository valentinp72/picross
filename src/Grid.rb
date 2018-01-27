require_relative 'Cell'

##
# Represent a grid, composed of cells

class Grid

	# @columns
	# @lines
	# @grid

	attr_reader :columns, :lines, :grid
	attr_writer :grid

	##
	# Create a grid of size line x columns  
	# lines      : an integer  
	# columns    : an integer
	# hypothesis : the future hypothesis of all created cells, if no hypothesis, the grid is not created.
	def initialize(lines, columns, hypothesis=nil)
		@lines   = lines
		@columns = columns

		if hypothesis != nil then
			@grid = Array.new(lines) { Array.new(columns) { Cell.new(hypothesis) } }
		end
	end

	##
	# Return an exact copy of self (every cell is duplicated)
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
	# Return the cell at position (line, column)
	def getCellPosition(line, column)
		if line >= @lines or line < 0 or column >= @columns or column < 0 then
			raise "InvalidCellPosition"
		end
		return @grid[line][column]
	end


	##
	# Return the cell, for debug printing
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

	def marshal_dump()
		return [@columns, @lines, @grid]
	end

	def marshal_load(array)
		@columns, @lines, @grid = array
	end

end
