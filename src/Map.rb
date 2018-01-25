##
# Map

class Map

	# @timeToDo
	# @difficulty
	# @hypotheses
	# @solution

	def initialize(timeToDo, difficulty, lines, columns, solutionGrid)
		@timeToDo   = timeToDo
		@difficulty = difficulty
		@hypotheses = Hypotheses.new(lines, columns)
		@solution   = solutionGrid
	end

	def Map.load(data)
		return Marshal.load(data)
	end

	def save()
		return Marshal.dump(self)
	end

	def reset()

	end

	def help(helpType)

	end

	def to_s()
		return "Difficulty: #{@difficulty}, time to do: #{@timeToDo}, hypotheses: #{@hypotheses}, solution: #{@solution}"
	end

	def marshal_dump()
		return [@timeToDo, @difficulty, @hypotheses, @solution]
	end

	def marshal_load(array)
		@timeToDo, @difficulty, @hypotheses, @solution = array
	end
end
