require_relative 'Timer'
require_relative 'Penalty'

##
# File          :: Statistics.rb
# Author        :: COHEN Mehdi, PELLOIN Valentin
# Licence       :: MIT Licence
# Creation date :: 01/27/2018
# Last update   :: 04/02/2018
#
# This class represents the player's statistics linked to a map.

class Statistic

	# The time the user has made (a Timer)
	attr_reader :time

	# The penalty the user has on his map (a Penalty)
	attr_reader :penalty

	# The number of used helps
	attr_reader :usedHelp

	# The number of stars he will get
	attr_reader :numberOfStars

	# The number of clicks he has made
	attr_reader :nbClick

	# Tells wether or not the game is finished
	attr_reader :isFinished
	attr_writer :isFinished

	##
	# Create a new Statistics object
	def initialize()
		@time    = Timer.new   # the time the user has made
		@penalty = Penalty.new # the penalty time on the map
		self.reset()
	end

	##
	# Set statistic's status to finished
	# and calculate numbers of stars awarded.
	# * *Arguments* :
	#   + +timeToDo+ -> the time the user has to resolve the map
	# * *Returns* :
	#   - the object itself
	def finish(timeToDo)
		# Time ratio / Stars
		#  1    -   - 3
		#  1.25 -   - 2.5
		#  1.5  -   - 2
		#  1.75 -   - 1.5
		#  2    -   - 1
		#  2.25 -   - 0.5
		#  2.5  -  - 0
		@time.pause
		@isFinished = true
		timeToDo = 600 if timeToDo == nil or timeToDo == 0
		puts (@time.elapsedSeconds + @penalty.seconds).to_s
		ratio = (@time.elapsedSeconds + @penalty.seconds) * 1.0 / (timeToDo * 1.0)
		ratio = (ratio * 4).round / 4.0
		@numberOfStars = -2*ratio + 5
		if(@numberOfStars > 3) then
			@numberOfStars = 3
		elsif @numberOfStars < 0
			@numberOfStars = 0
		end
		return self
	end

	##
	# Start the timer on this statistic.
	# * *Returns* :
	#   + the object itself
	def start
		@time.start
		return self
	end

	##
	# Increments the number of help used
	# * *Returns* :
	#   + the object itself
	def useHelp
		@usedHelp += 1
		return self
	end

	##
	# Increments the number of click
	# * *Returns* :
	#   + the object itself
	def click(nb = 1)
		@nbClick += nb
		return self
	end

	##
	# Reset Statistic
	# * *Returns* :
	#   + the object itself
	def reset()
		@time.reset
		@penalty.reset
		@usedHelp = 0
		@numberOfStars = 0
		@isFinished = false
		@nbClick = 0
		return self
	end

	##
	# Retuns the statistic to a string, for debug only
	# * *Returns* :
	#   - the statistic into a String object
	def to_s()
		res  = "Printing Statistic -#{self.object_id}-\n\t"
		res += " - Time       : #{@time}\n\t"
		res += " - Penalty    : #{@penalty}\n\t"
		res += " - isFinished : #{@isFinished}\n\t"
		res += " - Used help  : #{@usedHelp}\n\t"
		res += " - Nb Stars   : #{@numberOfStars}\n\t"
		res += " - NbClick    : #{@nbClick}\n\t"
		return res
	end

	##
	# Convert the statistic to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the statistic converted to an array
	def marshal_dump()
		return [@time, @usedHelp, @numberOfStars, @isFinished, @nbClick, @penalty]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a statistic object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the statistic object itself
	def marshal_load(array)
		@time, @usedHelp, @numberOfStars, @isFinished, @nbClick, @penalty = array
		return self
	end

end
