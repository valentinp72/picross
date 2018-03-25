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
		@style_context = self.style_context
		@style_context.add_class("number")
		@style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
		self.set_size_request(15, 15)
	end

	##
	# Add an hover to the solution number.
	# * *Returns* :
	#   - the object itself
	def setHover()
		addClass("hover")
		return self
	end

	##
	# Remove the hover of the solution number.
	# * *Returns* :
	#   - the object itself
	def unsetHover()
		removeClass("hover")
		return self
	end

	##
	# Add an indication that the SolutionNumber is done by the user.
	# * *Returns* :
	#   - the object itself
	def setDone
		addClass("done")
		return self
	end

	##
	# Remove the indication that the SolutionNumber is done by the user
	# * *Returns* :
	#   - the object itself
	def unsetDone
		removeClass("done")
		return self
	end

	##
	# Add a CSS class to the object, if not present.
	# * *Arguments*
	#   - +className+ -> the name of the CSS class to add
	# * *Returns* :
	#   - the object itself
	def addClass(className)
		begin
			if not @style_context.has_class?(className) then
				@style_context.add_class(className)
			end
		rescue NotImplementedError
			puts "addClass(#{className}): gobject-introspection error https://github.com/ruby-gnome2/ruby-gnome2/issues/1149"
		end
		return self
	end

	##
	# Remove a CSS class to the object, if present.
	# * *Arguments*
	#   - +className+ -> the name of the CSS class to remove
	# * *Returns* :
	#   - the object itself
	def removeClass(className)
		begin
			if @style_context.has_class?(className) then
				@style_context.remove_class(className)
			end
		rescue NotImplementedError
			puts "removeClass(#{className}): gobject-introspection error https://github.com/ruby-gnome2/ruby-gnome2/issues/1149"
		end
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
			.done {
				color: #D3D3D3;
			}
		"
	end

end
