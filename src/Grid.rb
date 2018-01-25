require_relative 'Cell'

##
# Represent a grid, composed of cells

class Grid

	# @columns
	# @lines
	# @grid

	##
	# Create a grid of size line x columns  
	# lines   : an integer  
	# columns : an integer
	def initialize(lines, columns)
		@lines   = lines
		@columns = columns
		@grid    = Array.new(lines) { Array.new(columns, Cell.new()) }
	end

	##
	# Return the cell, for debug printing
	def to_s()
		r = ""
		@grid.each do |lines|
			lines.each do |cell|
				r += cell.to_s
			end
			r += "\n"
		end
		return r
	end

end
