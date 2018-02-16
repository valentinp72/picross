##
# File		:: Timer.rb
# Author	:: Gilles Pastouret
# Licence	:: MIT Licence
# Creation date	:: 02/13/2018
# Last update	:: 02/14/2018
#
# This class represents a Timer
# 


### En chantier !!!

class Timer
	@elapsedTime
	@timerThread
	
	attr_reader :elapsedTime
	
	##
	# Create a new Timer object
	def initialize
		@elapsedTime = 0
	end
	
	def Thread.run
		startingTime = Time.now.to_i - @elapsedTime
		while true
			@elapsedTime = Time.now.to_i - startingTime
			sleep 0.2
		
			hh=(@elapsedTime/3600)
			mm=(@elapsedTime%3600)/60
			ss=@elapsedTime%60
		
			hr = hh<10? "0"+hh.to_s : hh.to_s
			min = mm<10 ? "0"+mm.to_s : mm.to_s
			sec = ss<10 ? "0"+ss.to_s : ss.to_s
			system "clear"
			puts hr+":"+min+":"+sec
		end
	end
		
	##
	def start
		@timerThread = Thread.new{}
		Thread.run
	end	
	##
	def pause
		@timerThread.join
	end
	
	def hours
		(@elapsedTime/3600)%24
	end
	def minutes
		(@elapsedTime%3600)/60
	end
	def seconds
		@elapsedTime%60
	end
end 

##Test

myTimer = Timer.new
myTimer.start
=begin
while true
	hh = myTimer.hours
	mm = myTimer.minutes
	ss = myTimer.seconds
	
	hr = hh<10? "0"+hh.to_s : hh.to_s
	min = mm<10 ? "0"+mm.to_s : mm.to_s
	sec = ss<10 ? "0"+ss.to_s : ss.to_s
	system "clear"
	puts hr+":"+min+":"+sec
	
	sleep 0.5
=end