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

	attr_reader :time, :usedHelp, :numberOfStars, :isFinished

	##
	# Create a new Statistics object
	# * *Arguments* :
	#   - +stats+		-> player's statistics
	def initialize()
		@time = 0
		@usedHelp = 0
		@numberOfStars = 0
		@isFinished = false
		@nbClick = 0
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
end
