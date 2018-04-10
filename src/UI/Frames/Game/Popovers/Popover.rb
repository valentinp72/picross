##
# File          :: Popover.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 05/04/2018
# Last update   :: 10/04/2018
# Version       :: 0.1
#
# This abstract class represents a povover in the application. 

class Popover < Gtk::Popover
	
	##
	# Create a new popover on a button
	# * *Arguments* :
	#   - +button+ -> the button the popover is linked on
	def initialize(button)
		super(button)
		
		self.position = :top
	end

	##
	# Abstract method to get the content (must be a Gtk::Widget)
	# of the Popover.
	def content
		raise NotImplementedError, "a Popover needs to know what to do when getting it's content"
	end

	##
	# Set the content of the popover
	# * *Returns* :
	#   - the object itself
	def setContent()
		self.children.each do |child|
			self.remove(child)
		end
		toAdd = self.content
		toAdd.show_all
		self.add(toAdd)
		return self
	end

	##
	# Update the content of the popover
	# * *Returns* :
	#   - the object itself
	def update
		self.setContent
		return self
	end

end
