require_relative 'Map'
require_relative 'User'
require_relative 'Help'
require_relative 'Helper'

##
# File          :: HelpLvl2.rb
# Author        :: Debonne Valentin
# Licence       :: MIT License
# Creation date :: 04/01/2018
# Last update   :: 04/07/2018
# Version       :: 0.1
#
# This class represents a medium help
class HelpLvl2 < Help

	# The cost of this help (in seconds)
	COST_HELP = 60

	def initialize(map, user)
		super(map, user, COST_HELP)
		@helper = Helper.new(@map)
	end

	def apply
		if(!@map.hasError? && !@map.shouldFinish?)
			super()	
			tabBox = @helper.traitement(@map, 2)
			tabBox.each do |box|
				y = box[0]
				x = box[1]
				stat = box[2]
				@map.grid.cellPosition(y, x).state=(stat)
			end
			@map.check
			return 0
		else 
			return 1
		end
	end

end
