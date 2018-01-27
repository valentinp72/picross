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
	
		# We create and push the default hypothesis
		defaultHypothesis      = Hypothesis.new(nil)
		defaultGrid            = Grid.new(lines, columns, defaultHypothesis)
		defaultHypothesis.grid = defaultGrid
		@stack.push(defaultHypothesis)
	end

	def getWorkingHypothesis()
		print @stack.last.class
		return @stack.last
	end
	
	def addNewHypothesis()
		newGrid = getWorkingHypothesis.grid.clone
		newHypothesis = Hypothesis.new(newGrid)
		@stack.push(newHypothesis)
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
		newBaseGrid = @stack[hypothesisID]
		@stack = @stack.slice(hypothesisID + 1..-1)
		@stack.unshift(newBaseGrid)
		return self
	end


	def to_s()
		rslt = "\n\n\nPRINTING ALL HYPOTHESES (#{@stack.length}): \n"
		@stack.reverse.each_with_index do |hypothesis, index|
			rslt += "n° #{@stack.length - index - 1} : "+ hypothesis.to_s + "\n"
		end
		return rslt
	end

	def marshal_dump()
		return [@lines, @columns, @stack]
	end

	def marshal_load(array)
		@lines, @columns, @stack = array
	end

end
