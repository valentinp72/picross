require 'set'

require_relative 'Grid'

class Drag

	attr_reader :changedCells
	attr_reader :wantedCell
	
	def initialize()
		self.reset
	end

	def startDrag(startCell, wantedCell)
		@startCell    = startCell
		@changedCells = Set[startCell]
		@wantedCell   = wantedCell

		@xDirection = nil
		@yDirection = nil
	end

	def startLeftDrag(startCell)
		startDrag(startCell, startCell.stateRotate.state)
	end

	def startRightDrag(startCell)
		startDrag(startCell, startCell.stateInvertCross.state)
	end

	def update(cell)
		if @startCell != nil && @wantedCell != nil then
			if @xDirection == nil || @yDirection == nil then
				calcDirections(cell)
			end
			if validDirections?(cell) then
				cell.state = @wantedCell
				@changedCells.add(cell)
			end
		end
	end

	def reset()
		@startCell    = nil
		@changedCells = Set[]
		@wantedCell   = nil
	end

	def calcDirections(cell)
		xWantedDir = calc(@startCell.posX, cell.posX)
		yWantedDir = calc(@startCell.posY, cell.posY)

		# a valid direction is only vertical or horizontal
		# => the direction is valid only if one of the two
		# dirs is 0
		nbZeros = [xWantedDir, yWantedDir].count(0)
		if nbZeros == 1 then
			@yDirection = yWantedDir
			@xDirection = xWantedDir
		end
	end

	def calc(startPos, currentPos)
		# clamp() is available in Ruby 2.4 only
		# https://bugs.ruby-lang.org/issues/10594
		# so this is a quick equivalent of 
		# return (currentPos - startPos).clamp(-1, 1)
		res = currentPos - startPos
		min = -1
		max = 1
		return [[max, res].min, min].max
	end

	def validDirections?(cell)
		if @yDirection != nil && @xDirection != nil then
			return validPos?(@yDirection, @startCell.posY, cell.posY) && validPos?(@xDirection, @startCell.posX, cell.posX)	
		end
		return false
	end

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
