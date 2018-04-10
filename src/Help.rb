require_relative 'Map'
require_relative 'User'

##
# File          :: Help.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/01/2018
# Last update   :: 04/01/2018
# Version       :: 0.1
#
# This abstract class represents an help type in the game.

class Help

	# The number of help this cost for the user
	COST_HELP = 30

	def initialize(map, user, cost)
		@map  = map
		@user = user
		@cost = cost
	end

	def apply
		@map.currentStat.useHelp
		begin
			puts "enough"
			@user.removeHelp(@cost/30)
		rescue User::NegativeAmountException
			puts "not enough"
			@map.currentStat.penalty.addPenalty(@cost)
		end
	end

end
