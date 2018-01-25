require_relative 'Cell'

##
# Represent a grid, composed of cells

class Grid

	# @columns
	# @lines
	# @grid

	attr_reader :columns, :lines, :grid

	##
	# Create a grid of size line x columns  
	# lines   : an integer  
	# columns : an integer
	def initialize(lines, columns)
		@lines   = lines
		@columns = columns
		@grid    = Array.new(lines) { Array.new(columns) { Cell.new() } }
	end

	##
	# Return the cell at position (line, column)
	def getCellPosition(line, column)
		if line > @lines or line < 0 or column > @columns or column < 0 then
			raise "InvalidCellPosition"
		end
		return @grid[line][column]
	end


	##
	# Return the cell, for debug printing
	def to_s()
		r = " "
		0.upto(@columns - 1) do |i|
			r += i.to_s
		end
		r += "\n"
		@grid.each_index do |j|
			r += j.to_s 
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
