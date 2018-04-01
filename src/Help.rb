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

	def initialize(map, user, cost)
		@map  = map
		@user = user
		@cost = cost
	end

	def apply
		
	end

end
