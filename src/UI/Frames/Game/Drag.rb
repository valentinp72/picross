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
	#   - +frame+ -> the frame the drag is working on 
	def initialize(map, cells, frame)
		@map   = map
		@grid  = map.hypotheses.getWorkingHypothesis.grid
		@cells = cells
		@frame = frame

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
		if !@map.currentStat.isFinished then
			@startCell  = startCell
			@wantedState = wantedState

			@xDirection = nil
			@yDirection = nil
		end
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
		if !@map.currentStat.isFinished then
			state = @map.rotateStateAt(startCell.posY, startCell.posX).state
			startDrag(startCell, state)
		end
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
		if !@map.currentStat.isFinished then
			startDrag(startCell,@map.rotateStateInvertAt(startCell.posY, startCell.posX).state)
			#startDrag(startCell, startCell.stateInvertCross.state)
		end
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
				if hasCameBack?(cell) then
					unupdateFromTo(@lastCell, cell)
					@lastCell = cell
				else
					@lastCell = cell
					updateFromTo(@startCell, cell)
				end
			else
				unupdateFromTo(@lastCell, cell)
			end
			
			@cursor.setText("#{self.dragLength} (#{self.totalLength})")
		end
		return self
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
		@startCell    = nil
		@lastCell     = nil
		@wantedState  = nil
		@changedCells = Hash.new()

		@map.check()
		if @map.evolving? && @map.evolved? && @frame.picross != nil then
			@frame.picross.redraw
		end
		@frame.checkMap

		if !@map.currentStat.time.isRunning && !@map.currentStat.isFinished then
			@map.currentStat.start
		end

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
		self.each_button_cell(fromCell, toCell) do |btn, cell|
			key = keyForCell(cell) 
			if not @changedCells.has_key?(key) then
				@changedCells[key] = cell.marshal_dump
				@map.rotateToStateAt(cell.posY, cell.posX, @wantedState)
				btn.setAttributes
			end
		end
		return self
	end

	##
	# Un-update all the cells between fromCell and toCell. Each cell 
	# will have it's state set back to it's previous one.
	# However, the cell in +toCell+ is not changed.
	# * *Arguments* :
	#   - +fromCell+ -> the first cell to start
	#   - +toCell+   -> the second cell to end the drag
	# * *Returns*
	#   - the object itself
	def unupdateFromTo(fromCell, toCell)
		self.each_button_cell(fromCell, toCell) do |btn, cell|
			next if cell == toCell
			key = keyForCell(cell)
			if @changedCells.has_key?(key) then
				@grid.cellPosition(cell.posY, cell.posX).marshal_load(@changedCells[key])	
				@changedCells.delete(key)
				btn.setAttributes
			end
		end
		return self
	end

	##
	# Loop through all the buttons and the cells between the two
	# given cells (including them).
	# Note that the two arguments doesn't have to be in any particular order,
		# and they should not be (it might not iterate from fromCell to toCell).
	# * *Arguments* :
	#   - +fromCell+ -> the first cell to start
	#   - +toCell+   -> the second cell to end
	# * *Returns* :
	#   - the object itself
	# * *Yields* :
	#   - a CellButton and a Cell for each cell between the two givens.
	def each_button_cell(fromCell, toCell)
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
				r = btn_cell_at(y, x)
				yield r[0], r[1] if r != []
			end
		end
		return self
	end

	##
	# Returns an Hash-key for a given cell
	# * *Arguments* :
	#   - +cell+ -> the cell to get it's Hash key
	# * *Returns* :
	#   - a String representing the key of this cell
	def keyForCell(cell)
		return "#{cell.posY},#{cell.posX}"
	end

	##
	# Returns an array, containing the button (CellButton) and the
	# cell (Cell) at the given coordinates in the grid 
	# (including the offsets caused by the SolutionNumber).
	# * *Arguments* :
	#   - +y+ -> the Y coordinate in the grid
	#   - +x+ -> the X coordinate in the grid
	# * *Returns* :
	#   - an Array of two elements, the CellButton and the Cell
	#   - an empty Array if there is no CellButton at the given coordinates
	def btn_cell_at(y, x)
		btn = @cells.get_child_at(x + @xOffset, y + @yOffset)
		if btn.kind_of?(CellButton) then
			cell = @grid.cellPosition(y, x)
			return [btn, cell]
		end
		return []
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
	# Returns true if the given cell is back in the drag that has been made.
	# For example, if the user goes too far, and then come back on it's drag, this will return true.
	# * *Arguments* :
	#   - +cell+ -> the cell to check if it has been reverted
	# * *Returns* :
	#   - true if the drag has been reverted 
	def hasCameBack?(cell)
		return false if @lastCell == nil
		if @xDirection != 0 then
			return calcDirection(cell.posX, @lastCell.posX) == @xDirection
		elsif @yDirection != 0 then
			return calcDirection(cell.posY, @lastCell.posY) == @yDirection
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
