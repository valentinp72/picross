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

	attr_reader :value

	##
	# Creation of a new SolutionNumber
	# * *Arguments* :
	#   - +numberValue+ -> the value to display inside the SolutionNumber
	def initialize(numberValue)
		super(numberValue.to_s)
		@value = numberValue
		
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: self.css)
		
		self.style_context.add_class("number")
		self.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
		self.set_size_request(15, 15)
	end

	##
	# Add an hover to the solution number.
	# * *Returns* :
	#   - the object itself
	def setHover()
		self.style_context.add_class("hover")
		return self
	end

	##
	# Remove the hover of the solution number.
	# * *Returns* :
	#   - the object itself
	def unsetHover()
		self.style_context.remove_class("hover")
		return self
	end

 	##
	# Returns the needed CSS for the label of a solution number
	# * *Returns* :
	#   - a String containing the CSS
	def css()
		"
			.number {
				color:  black;
				margin: 0px;
				padding-top:  1px;
				padding-left: 1px;
			}
			.hover {
				background-color: rgba(170, 20, 1, 0.2);
			}
		"
	end

end
