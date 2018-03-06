##
# File          :: PicrossFrame.rb
# Author        :: PELLOIN Valentin, BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/23/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class represents a number area for the solution indication of 
# the picross (at the top and the left).  

class SolutionNumber < Gtk::Label

	##
	# Creation of a new SolutionNumber
	# * *Arguments* :
	#   - +numberValue+ -> the value to display inside the SolutionNumber
	def initialize(numberValue)
		super(numberValue.to_s)
		
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: self.css)
		
		self.style_context.add_class("number")
		self.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
		self.set_size_request(15, 15)
	end

 	##
	# Returns the needed CSS for the label of a solution number
	# * *Returns* :
	#   - a String containing the CSS
	def css()
		"
			.number {
				/*border: 1px solid lightgray;*/
				/* background-color: #fe6a57; */
				color : black;
				margin:  0px;
				margin-top:  1px;
				margin-left: 1px;
			}
		"
	end

end
