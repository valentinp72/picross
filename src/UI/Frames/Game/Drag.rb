require_relative '../../../Grid'
require_relative 'CellButton'
require_relative 'CursorHelper'

##
# File          :: Drag.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/18/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class allows the player to change multiple Cell states, like a drag method.
# A drag generaly have an starting cell, and each time a new cell is a cell is updated
# by the drag, the drag changes all the cells between the starting cell and this one.
# Note that a drag can only be in one direction, to go on an other direction, you need
# to +reset+ the drag.

class Drag


	# The grid that the Drag is about (allowing to change the grid, for example to add a new hypothesis)
	attr_writer :grid

	##
	# Creation of a new Drag helper.
	# * *Arguments* :
	#   - +grid+  -> the grid that the drag will work on
	#   - +cells+ -> a Gtk::Grid grid, containing other cells, that the drag will change states when doing drags.
	def initialize(map, cells)
		@map   = map
		@grid  = map.hypotheses.getWorkingHypothesis.grid
		@cells = cells

		@xOffset = 0
		@yOffset = 0

		@cells.signal_connect('realize') do
			@cursor = CursorHelper.new(@cells.toplevel.window)	
		end
		self.reset
	end


	##
	# Set a new offset for the cells in the grid. This allows putting other
	# kind of object in the grid, and the Drag will not take care of them.
	# * *Arguments* :
	#   - +yOffset+ -> the new offset starting from the top
	#   - +xOffset+ -> the new offset starting from the left
	# * *Returns*
	#   - the object itself
	def setOffsets(yOffset, xOffset)
		@yOffset = yOffset
		@xOffset = xOffset
		return self
	end

	##
	# Tells the drag to start a new drag at the given cell, with the given wanted state.
	# This method also changes the state of the given cell to the new one.
	# * *Arguments* :
	#   - +startCell+   -> the Cell the Drag must start
	#   - +wantedState+ -> the wanted state for the Cell
	# * *Returns*
	#   - the object itself
	def startDrag(startCell, wantedState)
		@startCell  = startCell
		@wantedState = wantedState

		@xDirection = nil
		@yDirection = nil
		return self
	end

	##
	# Tells the Drag to start a new drag using the left button
	# of the mouse (a normal rotation using Cell::CELL_BLACK ->
	# Cell:CELL_WHITE -> Cell::CELL_BLACK -> ...)
	# * *Arguments* :
	#   - +startCell+ -> the cell to start the drag
	# * *Returns*
	#   - the object itself
	def startLeftDrag(startCell)
		startDrag(startCell, startCell.stateRotate.state)
		return self
	end

	##
	# Tells the Drag to start a new drag using the right button
	# of the mouse (a non-normal rotation using Cell::CELL_CROSSED ->
	# Cell:CELL_WHITE -> Cell::CELL_CROSSED -> ...)
	# * *Arguments* :
	#   - +startCell+ -> the cell to start the drag
	# * *Returns*
	#   - the object itself
	def startRightDrag(startCell)
		startDrag(startCell, startCell.stateInvertCross.state)
		return self
	end

	##
	# Update the state of all cells between the starting cell of the drag, and this cell.
	# All the cells will have the state of the starting cell.
	# * *Arguments* :
	#   - +cell+ -> the cell the mouse is currently on
	# * *Returns*
	#   - the object itself
	def update(cell)
		if @startCell != nil && @wantedState != nil then
			if @xDirection == nil || @yDirection == nil then
				calcDirections(cell)
			end
			if validDirections?(cell) then
				@lastCell = cell
				updateFromTo(@startCell, cell)
				@cursor.setText("#{self.dragLength} (#{self.totalLength})")
			end
		end
		return self
	end

	def unUpdate(cell)
		if @lastCell == cell then
			cell.state = cell.lastState
		end
	end

	##
	# Returns the length of the current drag, 0 if there is current drag.
	# * *Returns* :
	#   - the length of the drag
	def dragLength()
		if @startCell != nil && @lastCell != nil then
			xDiff = (@startCell.posX - @lastCell.posX).abs
			yDiff = (@startCell.posY - @lastCell.posY).abs
			return xDiff + yDiff + 1
		end
		return 0
	end

	##
	# Returns the total length of the cells concerned by the drag.
	# * *Returns* :
	#   - the length of the horizontal of vertical drag and the total size 
	#     of all the cells with the same state. 
	#   - 0 if there is no drag.
	def totalLength()
		if verticalDrag? then
			return @grid.totalLengthVertical(@startCell)
		end
		if horizontalDrag? then
			return @grid.totalLengthHorizontal(@startCell)
		end
		return 0
	end

	##
	# Reset the cell, no drag is currently active.
	# * *Returns*
	#   - the object itself
	def reset()
		@startCell   = nil
		@lastCell    = nil
		@wantedState = nil
		puts @map.check();

		if @cursor != nil then
			@cursor.reset
		end
		return self
	end

	##
	# Update all the cells between fromCell and toCell. Each cell will have the state
	# of +wantedState+.
	# Note that +fromCell+ and +toCell+ doesn't have to be in any specific order.
	# * *Arguments* :
	#   - +fromCell+ -> the first cell to start
	#   - +toCell+   -> the second cell to end the drag
	# * *Returns*
	#   - the object itself
	def updateFromTo(fromCell, toCell)
		yPositions = [fromCell.posY, toCell.posY]
		xPositions = [fromCell.posX, toCell.posX]

		# calc the start and end of each dimmension,
		# because we can't loop in descending (10..2).each doesn't work
		yStart = yPositions.min
		yEnd   = yPositions.max
		xStart = xPositions.min
		xEnd   = xPositions.max
		(yStart..yEnd).each do |y|
			(xStart..xEnd).each do |x|
				btn  = @cells.get_child_at(x + @xOffset, y + @yOffset)
				if btn.kind_of?(CellButton) then
					cell = @grid.getCellPosition(y, x)
					cell.state = @wantedState
					btn.setAttributes
				end
			end
		end
		return self
	end

	##
	# Calc the direction of the active drag, from +startCell+ to +cell+.
	# If the direction is not correct (a diagonal for example), the
	# directions are not updated.
	# * *Arguments* :
	#   - +cell+ -> the destination cell of the drag, used to process the directions
	# * *Returns*
	#   - the object itself
	def calcDirections(cell)
		xWantedDir = calcDirection(@startCell.posX, cell.posX)
		yWantedDir = calcDirection(@startCell.posY, cell.posY)

		# a valid direction is only vertical or horizontal
		# => the direction is valid only if one of the two
		# dirs is 0
		nbZeros = [xWantedDir, yWantedDir].count(0)
		if nbZeros == 1 then
			@yDirection = yWantedDir
			@xDirection = xWantedDir
		end
		return self
	end

	##
	# Compute the direction between the first number and the second.
	# * *Arguments* :
	#   - +startPos+   -> the starting position
	#   - +currentPos+ -> the end position
	# * *Returns* :
	#   - -1 if the direction is negative
	#   -  0 if the direction is null
	#   - +1 if the direction is positive
	def calcDirection(startPos, currentPos)
		# clamp() is available in Ruby 2.4 only
		# https://bugs.ruby-lang.org/issues/10594
		# so this is a quick equivalent of
		# return (currentPos - startPos).clamp(-1, 1)
		res = currentPos - startPos
		min = -1
		max = 1
		return [[max, res].min, min].max
	end

	##
	# Returns true if the given cell is in a valid direction compared to the start cell.
	# * *Arguments* :
	#   - +cell+ -> the cell to check directions are good
	# * *Returns* :
	#   - true if the directions are correct, false otherwise
	def validDirections?(cell)
		if @yDirection != nil && @xDirection != nil then
			return validPos?(@yDirection, @startCell.posY, cell.posY) && validPos?(@xDirection, @startCell.posX, cell.posX)
		end
		return false
	end

	##
	# Returns true if the drag is horizontal, false otherwise. If there is
	# no current drag, returns false.
	# * *Returns* :
	#   - true if the drag is horizontal
	def horizontalDrag?()
		return @xDirection != nil && @xDirection != 0
	end

	##
	# Returns true if the drag is vertical, false otherwise. If there is
	# no current drag, returns false.
	# * *Returns* :
	#   - true if the drag is vertical
	def verticalDrag?()
		return @yDirection != nil && @yDirection != 0
	end

	##
	# Returns true if the two positions are in the same direction as the given direction.
	# * *Arguments* :
	#   - +direction+  -> a direction (negative, 0, or positive)
	#   - +startPos+   -> the starting position to check the direction
	#   - +currentPos+ -> the ending position to check the direction
	# * *Returns* :
	#   - true if the two positions are aligned with the direction, false otherwise
	def validPos?(direction, startPos, currentPos)
		if direction == 0 then
			return currentPos == startPos
		elsif direction > 0 then
			return currentPos > startPos
		else
			return currentPos < startPos
		end
	end
end
