##
# File		:: Statistics.rb
# Author	:: COHEN Mehdi
# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 01/30/2018
#
# This class represents the player's statistics linked to a map
#
class Statistics

	# +stats+	- player's statistics on a map

	attr_reader :time, :usedHelp, :numberOfStars,

	attr_accessor :isFinished

	##
	# Create a new Statistics object
	# * *Arguments* :
	#   - +stats+		-> player's statistics
	def initialize()
		reset()
	end

	def finish(time,timeToDo)
		@time = time
		@isFinished = true
		@numberOfStars = (@time / timeToDo) / (usedHelp)
	end

	def useHelp()
		@usedHelp += 1
	end

	def click()
		@nbClick += 1
	end

	def reset()
		@time = 0
		@usedHelp = 0
		@numberOfStars = 0
		@isFinished = false
		@nbClick = 0
	end

	def Statistics.bestTime(array)
		array.min_by(&:time)
	end

	def Statistics.minHelp(array)
		array.min_by(&:usedHelp)
	end

	def Statistics.numberOfStars(array)
		array.max_by(&:numberOfStars)
	end

	def Statistics.minClick(array)
		array.min_by(&:nbClick)
	end

	def Statistics.nbFinished(array)
		array.select{|x| x.isFinished==true}.count
	end

end
