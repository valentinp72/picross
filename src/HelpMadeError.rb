require_relative 'Map'
require_relative 'User'
require_relative 'Help'

##
# File          :: HelpMadeError.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/01/2018
# Last update   :: 04/01/2018
# Version       :: 0.1
#
# This class represents an help allowing the user to go back
# where he has made an error. 

class HelpMadeError < Help

	# The cost of this help (in seconds)
	COST_HELP = 30

	def initialize(map, user)
		super(map, user, COST_HELP)
	end

	def apply
		super()	
		
		if @map.hasError? then
			puts "erreur ! voici avant :"
			puts @map.correctSaved
		else
			puts "pas d'erreur pauvre con"
		end
	end

end
