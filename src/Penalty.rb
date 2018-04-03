require_relative 'Timer'

##
# File          :: Penalty.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT Licence
# Creation date :: 04/02/2018
# Last update   :: 04/02/2018
#

class Penalty

	attr_reader :seconds

	def initialize
		self.reset
	end

	def addPenalty(seconds)
		@seconds += seconds
		return self
	end

	def elapsedTime
		return Timer.toTime(@seconds)
	end

	def reset
		@seconds = 0
	end

	##
	# Retuns the penalty to a string, for debug only
	# * *Returns* :
	#   - the penalty into a String object
	def to_s()
		res  = "Printing Penalty -#{self.object_id}-\n\t"
		res += " - elapsedTime : #{elapsedTime}\n\t"
		return res
	end
	
end
