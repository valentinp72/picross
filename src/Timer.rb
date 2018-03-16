##
# File          :: Timer.rb
# Author        :: COHEN Mehdi, PELLOIN Valentin
# Licence       :: MIT Licence
# Creation date :: 01/27/2018
# Last update   :: 03/08/2018
#
# This class represents a Timer. A timer can be started, and then, it can be paused. When paused,
# the timer can be started again (or unpaused). At any time, it's possible to get the total
# elapsed seconds by the timer. It's also possible to get the elapsed time of the timer in a human
# readable format (HH:MM::SS).

class Timer

	# Tells whether or not the timer is currently running
	attr_reader :isRunning

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
	# Return the total elapsed time by the timer, in a human-readable way.
	# * *Returns* :
	#   - the elapsed timer (String like "HH:MM:SS")
	def elapsedTime()
		return Time.at(self.elapsedSeconds).utc.strftime("%H:%M:%S")
	end

	##
	# Retuns the map to a string, for debug only
	# * *Returns* :
	#   - the map into a String object
	def to_s()
		res  = "Printing Timer -#{self.object_id}-\n\t"
		res += " - elapsedTime : #{elapsedTime}\n\t"
		return res
	end


end
