require_relative 'AssetsLoader'

##
# File          :: ButtonCreator.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/24/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
#
# This module helps to create various buttons (Gtk::Button) for the application.

module ButtonCreator

	##
	# Create a Gtk::Button with either a name, or an image.
	# * *Arguments* :
	#   - +name+      -> a String to show inside the button
	#   - +assetName+ -> the name of the asset image to load inside the button
	#   - +assetSize+ -> a new size to resize the image inside the button
	# * *Yields* :
	#   - if a block is given, yields it when the button is clicked
	# * *Returns* :
	#   - a Gtk::Button
	def ButtonCreator.new(name: nil, assetName: '', assetSize: nil)
		button = Gtk::Button.new(:label => name)

		if assetName != nil then
			button.image = AssetsLoader.loadImage(assetName, assetSize)
		end
		button.relief = Gtk::ReliefStyle::NONE

		if block_given? then
			button.signal_connect('clicked') { yield }
		end

		return button
	end

end
