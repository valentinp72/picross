require_relative 'Grid'

class Drag

	# @startPosition
	# @lastPosition

	def initialize(grid, yPos, xPos, shouldCross=false)
		@grid = grid
		
		@yStart = yPos
		@xStart = xPos
		@yLast  = yPos
		@xLast  = xPos

		cell = @grid.getCellPosition(yPos, xPos)
		if shouldCross then
			cell.stateInvertCross
		else
			cell.stateRotate
		end
		@newState = cell.state
	end

	def validDragPosition?(yPos, xPos)
		return yPos != nil && xPos != nil
	end

	def update(yNew, xNew)
		if validDragPosition?(yNew, xNew) then
			if yNew != @yLast || xNew != @xLast then

				if xNew == @xStart then
					# vertical line
					ys = [@yStart, yNew]
					ys.min.upto(ys.max) do |y|
						self.cellUpdate(y, @xStart)
					end
				elsif yNew == @yStart then
					# horizontal line
					xs = [@xStart, xNew]
					xs.min.upto(xs.max) do |x|
						self.cellUpdate(@yStart, x)
					end
				end

				@yLast = yNew
				@xLast = xNew
			end
		end
	end

	def cellUpdate(yPos, xPos)
		@grid.getCellPosition(yPos, xPos).state = @newState
	end

end
