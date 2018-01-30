require_relative 'Statistics'

##
# File		:: User.rb
# Author	:: COHEN Mehdi
# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 01/30/2018
#
# This class represents a user profile
# 
class User

	# +name+	- player's name
	# +statistics+	- player's statistics

	attr_accessor :pseudo

	##
	# Create a new Profile object
	# * *Arguments* :
	#   - +name+		-> a String representing the user's name
	#   - +statistics+	-> player's statistics
	def initialize(name, stats)
		@name = name
		@statistics = Statistics.new(stats)
	end

	##
	# * *Returns* :
	#   - player's statistics
	def getStats
		return @statistics.stats
	end

	##
	# Updates player's statistics
	# * *Returns* :
	#   - the new statistics
	def setStats(newStats)
		@statistics.stats = newStats
	end

	##
  	# Change the user's name
  	# * *Returns* :
	#   - the new name
  	def changeName(newName)
  	  @name = newName
  	end
end

=begin
x = "stats test"
y = "new stats test"
user = User.new("toto", x)
puts user.getStats
user.setStats(y)
puts user.getStats
=end
