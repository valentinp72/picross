##
# File          :: Cell.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 02/24/2018
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

<<<<<<< HEAD
	# List of all possible states in a ordered array
	LIST_CELLS   = [CELL_BLACK,   CELL_WHITE]

=======
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	# The state of the cell
	attr_reader :state

	# The hypothesis to this cell
	attr_reader :hypothesis
	attr_writer :hypothesis

<<<<<<< HEAD
=======
	# The next hypothesis when this cell changes state
	attr_writer :nextHypothesis

>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	# The cell X position
	attr_reader :posX
	# The cell Y position
	attr_reader :posY
<<<<<<< HEAD

	# +nextCells+  - The array of the nexts cells after rotation
	
	private_constant :LIST_CELLS
=======
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab

	##
	# Create a new cell, with a default state of CELL_WHITE .
	# * *Arguments* :
<<<<<<< HEAD
	#   - +hypothesis+ -> the hypothesis that this cell is belonging
	#   - +state+      -> the state the cell starts whith (default CELL_WHITE)
	def initialize(hypothesis, posY, posX, state=CELL_WHITE)
		@nextCells  = Array.new(LIST_CELLS)
		@state      = state
		@hypothesis = hypothesis
		@posY       = posY
		@posX       = posX

		# update the next cells so that the next one is just following the current state
		while @nextCells.last != @state do
			@nextCells.rotate!
		end
=======
	#   - +hypothesis+     -> the hypothesis that this cell is belonging
	#   - +posY+           -> the Y position of this cell in the grid
	#   - +posX+           -> the X position of this cell in the grid
	#   - +nextHypothesis+ -> if this cell changes, it's hypothesis will be +nextHypothesis+
	#   - +state+          -> the state the cell starts whith (default CELL_WHITE)
	def initialize(hypothesis, posY, posX, nextHypothesis = hypothesis, state=CELL_WHITE)
		@state          = state
		@hypothesis     = hypothesis
		@nextHypothesis = nextHypothesis
		@posY           = posY
		@posX           = posX
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	end

	##
	# Clone the current cell in a new cell.
	# The hypothesis is kept the same
	# * *Returns* :
	#   - the new cloned cell
	def clone()
<<<<<<< HEAD
		cState      = @state
		cHypothesis = @hypothesis
		cPosX       = @posX
		cPosY       = @posY
		return Cell.new(cHypothesis, cPosY, cPosX, cState)
=======
		cState          = @state
		cHypothesis     = @hypothesis
		cNextHypothesis = @nextHypothesis
		cPosX           = @posX
		cPosY           = @posY
		return Cell.new(cHypothesis, cPosY, cPosX, cNextHypothesis, cState)
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
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
			@hypothesis = @nextHypothesis
		end
		return self
	end

	##
	# Changes the state to the next one (WHITE -> BLACK -> WHITE ...).
	# If the cell state is currently CROSSED, the state will be converted to WHITE
	# * *Returns* :
	#   - the cell itself
	def stateRotate()
		if self.state == CELL_WHITE then
			self.state = CELL_BLACK
		else
			self.state = CELL_WHITE
		end
		return self
	end

	##
	# Changes the state of the cell with the cross (WHITE -> CROSSED -> WHITE ...).
	# If the cell state is currently BLACK, the state will be converted to CROSSED
	# * *Returns* :
	#    - the cell itself
	def stateInvertCross()
		if self.state == CELL_CROSSED then
			self.state = CELL_WHITE
		else
			self.state = CELL_CROSSED
		end
		return self
	end

	def stateInvertCross()
		if self.state == CELL_CROSSED then
			self.state = CELL_WHITE
		else
			self.state = CELL_CROSSED
		end
		return self
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
	# Compare the cell to the one given as parameter.
	# * *Returns* :
	#   - true if the cells are the same
	def compare(cell)
		if @state == CELL_WHITE || @state == CELL_CROSSED then
			if cell.state == CELL_WHITE || cell.state == CELL_CROSSED then
				return true
			end
		elsif @state == CELL_BLACK then
			if cell.state == CELL_BLACK then
				return true
			end
		end
		return false
	end

	##
	# Convert the cell to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the cell converted to an array
	def marshal_dump()
<<<<<<< HEAD
		return [@state, @hypothesis, @posY, @posX]
=======
		return [@state, @hypothesis, @posY, @posX, @nextHypothesis]
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a cell.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the cell itself
	def marshal_load(array)
<<<<<<< HEAD
		@state, @hypothesis, @posY, @posX = array
		initialize(@hypothesis, @posY, @posX, @state)
=======
		@state, @hypothesis, @posY, @posX, @nextHypothesis = array
		initialize(@hypothesis, @posY, @posX, @nextHypothesis, @state)
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
		return self
	end

end
