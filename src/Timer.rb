##
# File          :: Timer.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT Licence
# Creation date :: 01/27/2018
# Last update   :: 04/02/2018
#
# This class represents a Timer. A timer can be started, and then, it can be paused. When paused,
# the timer can be started again (or unpaused). At any time, it's possible to get the total
# elapsed seconds by the timer. It's also possible to get the elapsed time of the timer in a human
# readable format (HH:MM::SS).

class Timer

	# Tells whether or not the timer is currently running
	attr_reader :isRunning

	attr_reader :isNegative

	##
	# Creation of a new Timer.
	def initialize()
		@startTimes = Array.new()
		@endTimes   = Array.new()
		@isRunning  = false
	end

	##
	# Tells the timer to start counting. This method
	# does not overwrite the current elapsed time, it
	# add new times to it.
	# * *Returns* :
	#   - the timer itself
	def start()
		if not self.isRunning then
			@startTimes.push(Time.now)
			@isRunning = true
		end
		return self
	end

	##
	# Tells the timer to pause. To start again the timer, you
	# can use +start+ or +unpause+.
	# * *Returns* :
	#   - the timer itself
	def pause()
		if self.isRunning then
			@endTimes.push(Time.now)
			@isRunning = false
		end
		return self
	end

	alias unpause start

	##
	# Reset the timer
	# * *Returns* :
	#   - itself
	def reset()
		@startTimes.clear
		@endTimes.clear
		@isRunning = false

		return self
	end

	##
	# Returns the total number of elapsed seconds since the timer began.
	# It count the time of each run of the timer (pauses).
	# * *Returns* :
	#   - the elapsed seconds (Integer)
	def elapsedSeconds()
		time = 0
		@startTimes.zip(@endTimes) do |startTime, endTime|
			endTime = Time.now if endTime == nil
			time += endTime - startTime
		end
		return time
	end

	##
	# Return a printable time from seconds.
	# * *Returns* :
	#   - the seconds in a human-readable way (String like "HH:MM:SS")
	def Timer.toTime(seconds)
		return Time.at(seconds).utc.strftime("%H:%M:%S")
	end

	##
	# Return the total elapsed time by the timer, in a human-readable way.
	# * *Returns* :
	#   - the elapsed time (String like "HH:MM:SS")
	def elapsedTime()
		return Timer.toTime(self.elapsedSeconds)
	end

	def remaining(addPenalty, maxTime)
		total  = addPenalty + self.elapsedSeconds
		remain = maxTime - total
		@isNegative = false
		@isNegative = true if remain <= 0
		return remain.abs
	end

	##
	# Retuns the timer to a string, for debug only
	# * *Returns* :
	#   - the penalty into a String object
	def to_s()
		res  = "Printing Timer -#{self.object_id}-\n\t"
		res += " - elapsedTime : #{elapsedTime}\n\t"
		return res
	end

	##
	# Convert the timer to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the map converted to an array
	def marshal_dump()
		return [@startTimes, @endTimes, @isRunning]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a timer object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the timer object itself
	def marshal_load(array)
		@startTimes, @endTimes, @isRunning = array
		return self
	end

end
