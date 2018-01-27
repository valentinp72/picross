## 
# This class represents a cell in a Picross.  
# Each cell have a state (white, black or crossed when the player is sure the cell should be white).  
# The cells also have a link to its hypothesis.

class Cell

	# Cell states : either CELL_WHITE, CELL_BLACK, or CELL_CROSSED
		# Default state, the cell is white
		CELL_WHITE   = 0 
		# The cell state is colored 
		CELL_BLACK   = 1 
		# The cell state is white, and should remain (crossed)
		CELL_CROSSED = 2

	# List of all possible states in a ordered array
	LIST_CELLS   = [CELL_BLACK, CELL_CROSSED, CELL_WHITE]

	# * +state+      - The state of the cell
	# * +nextCells+  - The array of the nexts cells after rotation
	# * +hypothesis+ - The hypothesis to this cell

	attr_reader :state
	private_constant :LIST_CELLS

	##
	# Create a new cell, with a default state of CELL_WHITE 
	# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis that this cell is belonging
	#   - +state+ -> the state the cell starts whith (default CELL_WHITE)
	def initialize(hypothesis, state=CELL_WHITE)
		@nextCells  = Array.new(LIST_CELLS)
		@state      = state
		@hypothesis = hypothesis

		# update the next cells so that the next one is just following the current state
		while @nextCells.last != @state do
			@nextCells.rotate!
		end
	end

	##
	# Clone the current cell in a new cell.  
	# The hypothesis is kept the same 
	def clone()
		cState      = @state
		cHypothesis = @hypothesis
		return Cell.new(cHypothesis, cState)
	end

	##
	# Change the cell state to state
	# * *Arguments* :
	#   - +state+ -> the state to put the cell at
	# * *Raises* :
	#   - +ArgumentError+ -> if state is not valide (not CELL_WHITE, CELL_BLACK or CELL_CROSSED)
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
