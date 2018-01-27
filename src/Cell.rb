## 
# This class represents a cell in a Picross  

class Cell

	##
	# Cell states : either CELL_EMPTY, CELL_CROSSED, or CELL_FULL
	CELL_WHITE   = 0 # default cell
	CELL_BLACK   = 1 # black
	CELL_CROSSED = 2 # cross 

	# List of all possible states in a ordered array
	LIST_CELLS   = [CELL_BLACK, CELL_CROSSED, CELL_WHITE]

	# @state      - The state of the cell
	# @nextCells  - The array of the nexts cells after rotation
	# @hypothesis - The hypothesis to this cell

	attr_reader :state

	##
	# Create a new cell
	# The default state is CELL_EMPTY 
	def initialize(hypothesis, state=CELL_WHITE, nextCells=Array.new(LIST_CELLS))
		@nextCells  = nextCells
		@state      = state
		@hypothesis = hypothesis
	end

	##
	# Clone the current cell in a new cell
	# The hypothesis is kept the same 
	def clone()
		cNextCells  = @nextCells.clone
		cState      = @state
		cHypothesis = @hypothesis
		return Cell.new(cHypothesis, cState, cNextCells)
	end

	##
	# Change the cell state to state
	# If state is not valid (CELL_EMPTY, CELL_CROSSED, CELL_FULL), raise an ArgumentError exception
	def state=(state)
		if state != CELL_WHITE and state != CELL_BLACK and state != CELL_CROSSED then
			raise ArgumentError, 'Argument state should be a valid state!'
		else
			@state = state
		end
		return self
	end

	##
	# Change the state to the next one (EMPTY -> FULL -> CROSSED -> EMPTY ...)
	def stateRotate()
		self.state = @nextCells.first
		@nextCells.rotate!
		return self
	end

	##
	# Return the cell to a printable String
	def to_s()
		case @state
			when CELL_WHITE
				return "░"
			when CELL_CROSSED
				return "X"
			when CELL_BLACK
				return "█"
		end
		raise "Wrong cell state"
	end

	def marshal_dump()
		return [@nextCells, @state, @hypothesis]
	end

	def marshal_load(array)
		@nextCells, @state, @hypothesis = array
	end

end
