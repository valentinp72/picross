##
# File		:: Timer.rb
# Author	:: COHEN Mehdi
# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 01/30/2018
#
# This class represents a Timer
# 
class Timer

	# +timer+	- basic timer

	attr_reader :time

	##
	# Create a new Timer object
	# * *Arguments* :
	#   - +time+		-> basic timer (hh/mm/ss)
	def initialize(t=0)
		@time = t
	end

	##
    	# Method for launching a timer
	# * *Returns* :
	#   - the time passed since the launching
	def startTimer

		while true
			sleep 1
			@time +=1
          		hours = @time/3600
    			min = (@time - (hours*3600)) / 60
    			sec = @time - (hours*3600) - (min*60)

    			h = hours < 10 ? "0" + hours.to_s : hours.to_s
    			m = min < 10 ? "0" + min.to_s : min.to_s
    			s = sec < 10 ? "0" + sec.to_s : sec.to_s
          		system "clear"
    			puts h + ":" + m + ":" + s
		end

	end

end #Timer class

=begin
timer = Timer.new(0)
timer.startTimer()
=end
