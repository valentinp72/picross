##
# File		:: Timer.rb
# Author	:: Gilles Pastouret
# Licence	:: MIT Licence
# Creation date	:: 02/13/2018
# Last update	:: 02/14/2018
#
# This class represents a Timer
# 
class Timer
	@timerThread
	@elapsedTime
	
	private_class_method :new
	
	def Timer.create(sec=0)
		new(sec)
	end
	
	##
	# Create a new Timer object
	def initialize(sec)
		@elapsedTime = sec
	end
	##
	# Method for launching a timer
	def start
		unless @timerThread == nil
			@timerThread.wakeup
		else
			@timerThread = Thread.new(@elapsedTime) 
			{ |startingTime|
				startingTime += Time.now.to_i
				while true
					elapsedT = Time.now.to_i - startingTime
					hh = elapsedT/3600
					mm = (elapsedT%3600)/60
					ss = elapsedT%60
					
					%%interface%
					hr = hh<10? "0"+hh.to_s : hh.to_s
					min = mm<10 ? "0"+mm.to_s : mm.to_s
					sec = ss<10 ? "0"+ss.to_s : ss.to_s
			  		system "clear"
					puts hr+":"+min+":"+sec
				end
			}
		end
	end	
		
	
	def pause
		Thread.stop()
	end
	
	def stop
		@timerThread.join
	end

end 