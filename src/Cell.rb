## 
# File          :: Cell.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# This class represents a cell in a Picross.  
# Each cell have a state (white, black or crossed when the player is sure the cell should be white).
# The cells also have a link to its hypothesis.

class Cell

	# Default state, the cell is white
	CELL_WHITE   = 0 
	# The cell state is colored 
	CELL_BLACK   = 1 
	# The cell state is white, and should remain (crossed)
	CELL_CROSSED = 2

	# List of all possible states in a ordered array
	LIST_CELLS   = [CELL_BLACK,   CELL_WHITE]

	# The state of the cell
	attr_reader :state
	
	# The hypothesis to this cell
	attr_reader :hypothesis
	attr_writer :hypothesis

	# +nextCells+  - The array of the nexts cells after rotation
	
	private_constant :LIST_CELLS

	##
	# Create a new cell, with a default state of CELL_WHITE .
	# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis that this cell is belonging
	#   - +state+      -> the state the cell starts whith (default CELL_WHITE)
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
	# * *Returns* :
	#   - the new cloned cell
	def clone()
		cState      = @state
		cHypothesis = @hypothesis
		return Cell.new(cHypothesis, cState)
	end

	##
	# Change the cell state to state.
	# * *Arguments* :
	#   - +state+ -> the state to put the cell at
	# * *Returns* :
	#   - the cell itself
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
	# Change the state to the next one (EMPTY -> FULL -> CROSSED -> EMPTY ...).
	# * *Returns* :
	#   - the cell itself
	def stateRotate()
		self.state = @nextCells.first
		@nextCells.rotate!
		return self
	end

	def stateInvertCross()
		if self.state == CELL_CROSSED then
			self.state = CELL_WHITE
		else
			self.state = CELL_CROSSED
		end
	end

	##
	# Return the cell to a printable String.
	# * *Returns* :
	#   - the cell converted to a String
	def to_s()
		case @state
			when CELL_WHITE
				return "█"
			when CELL_CROSSED
				return "X"
			when CELL_BLACK
				return "░"
		end
		raise "Wrong cell state"
	end

	##
	# Convert the cell to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the cell converted to an array
	def marshal_dump()
		return [@state, @hypothesis]
	end

	##
	# Update all the instances variables from the array given, 
	# allowing Marshal to load a cell.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the cell itself
	def marshal_load(array)
		@state, @hypothesis = array
		initialize(@hypothesis, @state)
		return self
	end

end
