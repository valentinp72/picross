require_relative 'Grid'

class Drag

	def initialize()
		self.reset
	end

	def startDrag(startCell, wantedCell)
		@startCell  = startCell
		@wantedCell = wantedCell 
		puts "Nouveau drag"
		puts "Drag: #{@startCell}, #{@wantedCell}"
	end

	def startLeftDrag(startCell)
		puts "Left drag begin"
		startDrag(startCell, startCell.stateRotate.state)
	end

	def startRightDrag(startCell)
		puts "Right drag begin"
		startDrag(startCell, startCell.stateInvertCross.state)
	end

	def update(cell)
		puts "Drag: #{@startCell}, #{@wantedCell}"
		if @startCell != nil && @wantedCell != nil then
			cell.state = @wantedCell
		else
#:print "Error: drag not started, and no wanted cell"
		end
	end

	def reset()
		puts "rest du drag"
		@startCell  = nil
		@wantedCell = nil
	end

end
