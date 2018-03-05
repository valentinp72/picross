require_relative '../../../Cell'

require_relative 'Drag'
require_relative 'CellButton'
require_relative 'SolutionNumber'

##
# File          :: PicrossFrame.rb
# Author        :: PELLOIN Valentin, BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/23/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class represents a Frame for the Picross view.
# Inside this frame, there are multiple CellButton that can be clicked (or dragged using the Drag class) to resolve the game.

class PicrossFrame < Frame

	##
# Creation of a new PicrossFrame.
# * *Arguments* :
#   - +grid+           -> the Grid of the PicrossFrame view
#   - +columnSolution+ -> the numbers to display as the solution at the top (see Map.
#   clmSolution)
#   - +lineSolution+   -> the numbers to display as the solution at the left (see Map.lneSolution)
	def initialize(map, grid)
		super()
		self.border_width = 10

		@map = map
		@grid = grid
		@lineSolution   = map.lneSolution
		@columnSolution = map.clmSolution

		self.signal_connect('size-allocate') do
			self.setMaxSize(self.allocation.width, self.allocation.height)
		end
#self.signal_connect('realize') do
#			puts "Hey"
#			puts self.allocation.inspect
#			self.setMaxSize(400, 400)
#		end
		self.queue_allocate
		createArea()
	end

	def setMaxSize(width, height)
		if @oWidth != width || @oHeight != height then
			cellX = width  / (@grid.columns + @lineOffset)
			cellY = height / (@grid.lines + @columnOffset)

			cellSize = [cellX, cellY].min - 1

			CellButton.resize(cellSize, cellSize)
			self.queue_draw
			
			@cells.each do |cell|
				if cell.kind_of?(CellButton) then
					cell.resize
				end
			end

			@oHeight = height
			@oWidth  = width
		end
	end

	##
	# Changes the grid to display on the PicrossFrame view.
	# This takes care of everything, it update the Drag, and the cells inside the frame.
	# * *Arguments* :
	#   - +newGrid+ -> the new Grid to display
	# * *Returns* :
	#   - the PicrossFrame itself
	def grid=(newGrid)

		@grid = newGrid
		@drag.grid = @grid

		@grid.each_cell_with_index do |cell, line, column|
			@cells.get_child_at(@lineOffset + column, @columnOffset + line).cell = cell
		end
		return self
	end

	##
	# Create the PicrossFrame area, with all the CellButton inside
	# * *Returns* :
	#   - the PicrossFrame itself
	def createArea()
		@cells = Gtk::Grid.new
#		@cells.row_homogeneous    = true
#		@cells.column_homogeneous = true
		@drag  = Drag.new(@map, @cells)

		# compute the offsets caused by the line and column solution numbers
		@lineOffset   = @lineSolution.map(&:length).max
		@columnOffset = @columnSolution.map(&:length).max
		@drag.setOffsets(@columnOffset, @lineOffset)

		# adds the numbers to the cells
		createNumbers(@cells, @columnSolution, @lineOffset, @columnOffset, false)
		createNumbers(@cells, @lineSolution,   @lineOffset, @columnOffset, true)

		# creation of all the cells buttons
		@grid.each_cell_with_index do |cell, line, column|
			@cells.attach(CellButton.new(cell, @drag), column + @lineOffset, line + @columnOffset, 1, 1)
		end

		add(@cells)
		return self
	end

	##
	# Adds all the solution numbers to the grid cells.
	# If +isHorizontal+ equals true, then it adds all the left numbers,
	# otherwise, the top numbers.
	# * *Arguments* :
	#   - +cells+        -> the Gtk::Grid to add the numbers to
	#   - +solution+     -> the array of array of numbers containing the solution
	#   - +lineOffset+   -> the top offset
	#   - +columnOffset+ -> the left offset
	# * *Returns* :
	#   - the PicrossFrame itself
	def createNumbers(cells, solution, lineOffset, columnOffset, isHorizontal)

		isHorizontal ? offset = lineOffset : offset = columnOffset
		i = 0
		solution.each do |n|
			j = 0
			n = n.reverse.fill(n.size..offset - 1){ nil }
			n.reverse.each do |m|
				addNumber(m, isHorizontal, lineOffset, columnOffset, i, j, cells)
				j+= 1
			end
			i+= 1
		end

		return self
	end

	##
	# Create a new SolutionNumber and adds it to the grid
	# * *Arguments* :
	#   - +value+        -> the value of the SolutionNumber
	#   - +isHorizontal+ -> are we doing the horizontal solution, or the vertical solution?
	#   - +lineOffset+   -> the top offset
	#   - +columnOffset+ -> the left offset
	#   - +i+            -> the index of the array in the solution
	#   - +j+            -> the index of the number inside the array
	# * *Returns* :
	#   - the PicrossFrame itself
	def addNumber(value, isHorizontal, lineOffset, columnOffset, i, j, cells)
		number = SolutionNumber.new(value)
		if isHorizontal then
			cells.attach(number,j,i+columnOffset,1,1)
		else
			cells.attach(number,i+lineOffset,j,1,1)
		end
		return self
	end

end
