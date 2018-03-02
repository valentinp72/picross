##
# File          :: StatisticsArray.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 03/02/2018
# Last update   :: 03/02/2018
# Version       :: 0.1
#
# This class represents an array of statistics. This is a stack of Statistic.
# Statistic are added to the array only when the map is finished.
class StatisticsArray

	##
	# +stack+   - An array of Statistic used as a stack

	# Creation of a stack of hypothesis, ie an Hypotheses.
	# This automatically create a default hypothesis, with an empty grid
	# inside.
	# * *Arguments* :
	#   - +lines+   -> the number of line of the hypotheses
	#   - +columns+ -> the number of columns of the hypotheses
	def initialize()
		@stack   = Array.new()
	end

	##
	# Return the last statistic added
	# * *Returns* :
	#   - statistic
	def getLastStatistic()
		return @stack.last
	end

	##
	# Add a new statistic to the stack of Statistic.
	# * *Returns* :
	#   - the id of the add statistic in the stack
	def addStatistic(stat)
		@stack.push(stat)
		return @stack.length - 1
	end

	##
	# Converts the StatisticsArray to a String, for printing
	# * *Returns* :
	#   - the StatisticsArray into a String
	def to_s()
		rslt = "\n\n\nPRINTING ALL STATISTICS (#{@stack.length}): \n"
		@stack.reverse.each_with_index do |stat, index|
			rslt += "n° #{@stack.length - index - 1} : "+ stat.to_s + "\n"
		end
		return rslt
	end

	def bestTime()
		@stack.min_by(&:time)
	end

	def minHelp()
		@stack.min_by(&:usedHelp)
	end

	def numberOfStars()
		@stack.max_by(&:numberOfStars)
	end

	def minClick()
		@stack.min_by(&:nbClick)
	end

	def nbFinished()
		@stack.select{|x| x.isFinished==true}.count
	end



	##
	# Convert the StatisticsArray to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the StatisticsArray converted to an array
	def marshal_dump()
		return [@stack]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a StatisticsArray object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the StatisticsArray object itself
	def marshal_load(array)
		@stack = array
		return self
	end

end
