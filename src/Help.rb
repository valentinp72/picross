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

	def initialize(map, user, costSeconds)
		@map  = map
		@user = user
		@cost = costSeconds
	end

	def apply()
		@map.currentStat.useHelp
		begin
			@user.removeHelp(self.costHelps)
		rescue User::NegativeAmountException
			@map.currentStat.penalty.addPenalty(self.costSeconds)
		end
	end

	def costSeconds
		return @cost
	end

	def costHelps
		return self.costSeconds / 30
	end

end
