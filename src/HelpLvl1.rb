require_relative 'Map'
require_relative 'User'
require_relative 'Help'
require_relative 'Helper'

##
# File          :: HelpLvl1.rb
# Author        :: Debonne Valentin
# Licence       :: MIT License
# Creation date :: 04/01/2018
# Last update   :: 04/07/2018
# Version       :: 0.1
#
# This class represents a big help
class HelpLvl1 < Help

	# The cost of this help (in seconds)
	COST_HELP = 120

	def initialize(map, user)
		super(map, user, COST_HELP)
		@helper = Helper.new(@map)
	end

	def apply
		super()	
		tabBox = @helper.traitement(@map, 1)
		tabBox.each do |box|
			y = box[0]
			x = box[1]
			stat = box[2]
			@map.grid.cellPosition(y, x).state=(stat)
		end
	end

end
