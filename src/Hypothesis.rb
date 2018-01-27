##
# This class represent an hypothesis  
# An hypothesis is a stack of grids, where the top one is the current game

class Hypothesis

	# @grid
	# @color

	attr_reader :grid
	attr_writer :grid

	def initialize(grid)
		@grid  = grid
		@color = {"RED" => rand(0..255), "GREEN" => rand(0..255), "BLUE" => rand(0..255)}
	end

	def to_s()
		return "Color: #{@color}\n" + @grid.to_s
	end

end
