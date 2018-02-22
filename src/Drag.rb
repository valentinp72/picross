require_relative 'Grid'

class Drag

	def initialize()
		self.reset
	end

	def startDrag(startCell, wantedCell)
		@startCell  = startCell
		@wantedCell = wantedCell 
	end

	def startLeftDrag(startCell)
		startDrag(startCell, startCell.stateRotate.state)
	end

	def startRightDrag(startCell)
		startDrag(startCell, startCell.stateInvertCross.state)
	end

	def update(cell)
		if @startCell != nil && @wantedCell != nil then
			cell.state = @wantedCell
		end
	end

	def reset()
		@startCell  = nil
		@wantedCell = nil
	end

end
