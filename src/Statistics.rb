##
# File		:: Statistics.rb
# Author	:: COHEN Mehdi
# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 01/30/2018
#
# This class represents the player's statistics linked to a map
#
class Statistic

	# +stats+	- player's statistics on a map

	attr_reader :time, :usedHelp, :numberOfStars

	attr_accessor :isFinished

	##
	# Create a new Statistics object
	# * *Arguments* :
	#   - +stats+		-> player's statistics
	def initialize()
		reset()
	end

	def finish(timeToDo)
		#time = @timer.getTime()

		#  1    -   - 3
		#  1.25 -   - 2.5
		#  1.5  -   - 2
		#  1.75 -   - 1.5
		#  2    -   - 1
		#  2.25 -   - 0.5
		#  2.5  -  - 0
		#
		 @isFinished = true
		 ratio = time / timeToDo
		 #return the number of stars depending on the ratio above
		 @numberOfStars = -2*ratio + 5


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

	##
	# Convert the statistic to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the statistic converted to an array
	def marshal_dump()
		return [@time, @used, @numberOfStars, @isFinished, @nbClick]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a statistic object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the statistic object itself
	def marshal_load(array)
		@time, @used, @numberOfStars, @isFinished, @nbClick = array
		return self
	end

end
