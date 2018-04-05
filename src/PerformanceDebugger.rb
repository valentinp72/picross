##
# File          :: PerformanceDebugger.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/05/2018
# Last update   :: 04/05/2018
# Version       :: 0.1
#
# This module helps to debug performances of chunks of code.

module PerformanceDebugger

	##
	# Execute a block (yield) and then, print the total time
	# in seconds the code has taken.
	# * *Yields* :
	#   - a block you can put instructions in it to get the execution time
	# * *Returns* :
	#   - the elapsed time in seconds
	def PerformanceDebugger.showTime()
		before  = Time.now
		yield
		after   = Time.now
		elapsed = after - before
		puts "PerformanceDebugger.showTime: elapsed time: #{elapsed} seconds"
		return elapsed
	end

end
