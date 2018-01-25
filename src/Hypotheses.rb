require_relative 'Hypothesis'
require_relative 'Grid'
require_relative 'Cell'

class Hypotheses

	# @lines
	# @columns
	# @stack : An array of hypothesis used as a stack

	def initialize(lines, columns)
		@stack   = Array.new()
		@lines   = lines
		@columns = columns

		addNewHypothesis()
	end

	def getWorkingHypothesis()
		return @stack.last
	end
	
	def addNewHypothesis()
		@stack.push(Hypothesis.new(Grid.new(@lines, @columns)))
		return @stack.length - 1
	end

	def reject(hypothesisID)
		if hypothesisID <= 0 or hypothesisID >= @stack.length then
			raise ArgumentError, "hypothesisID is not a valid ID in the stack"
		end
		
		@stack.pop(@stack.length - hypothesisID)
		return self
	end

	def validate(hypothesisID)
		if hypothesisID < 0 or hypothesisID >= @stack.length then
			raise ArgumentError, "hypothesisID is not a valid ID in the stack"
		end
		newBaseGrid = getGlobalGrid(hypothesisID)
		@stack = @stack.slice(hypothesisID + 1..-1)
		@stack.unshift(Hypothesis.new(newBaseGrid))
	end


	def getGlobalGrid(maxHypothesis)
		grid = Grid.new(@lines, @columns)
	
		@stack.take(maxHypothesis + 1).each do |hypothesis|
			tmpGrid = hypothesis.grid

			0.upto(@lines - 1) do |j|
				0.upto(@columns - 1) do |i|
					if tmpGrid.grid[j][i].state != Cell::CELL_EMPTY then
						grid.grid[j][i] = tmpGrid.grid[j][i]
					end
				end
			end

		end
		return grid
	end

	def to_s()
		rslt = "\n\n\nPRINTING HYPOTHESES SUM: \n"
		@stack.reverse.each do |hypothesis|
			rslt += hypothesis.to_s + "\n"
		end
		rslt += "\n===>\n" + getGlobalGrid(@stack.length - 1).to_s
		return rslt
	end

	def marshal_dump()
		return [@lines, @columns, @stack]
	end

	def marshal_load(array)
		@lines, @columns, @stack = array
	end

end
