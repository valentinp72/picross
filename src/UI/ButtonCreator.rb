require_relative 'AssetsLoader'

##
# File          :: ButtonCreator.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/25/2018
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
	#   - +clicked+   -> a method name to call on +parent+ when the button is called
	#   - +released+  -> a method name to call on +parent+ when the button is released
	#   - +parent+    -> the parent to call the methods +clicked+ and +released+ on
	#   - +relief+    -> tells if the button should have a border 
	# * *Returns* :
	#   - a Gtk::Button
	def ButtonCreator.new(name: nil, assetName: '', assetSize: nil, clicked: nil, released: nil, parent: nil, relief: false)
		button = Gtk::Button.new(:label => name)

		if assetName != nil then
			button.image = AssetsLoader.loadImage(assetName, assetSize)
		end
		if not relief then
			button.relief = Gtk::ReliefStyle::NONE
		end

		if parent != nil then
			if clicked != nil then
				button.signal_connect('clicked') { parent.send(clicked) }
			end
			if released != nil then
				button.signal_connect('released') { parent.send(released) }
			end
		end

		return button
	end

	##
	# Create a Gtk::Button like ButtonCreator.new, but 
	# with a relief (a normal button).
	# * *Arguments* :
	#   - +name+      -> a String to show inside the button
	#   - +assetName+ -> the name of the asset image to load inside the button
	#   - +assetSize+ -> a new size to resize the image inside the button
	#   - +clicked+   -> a method name to call on +parent+ when the button is called
	#   - +released+  -> a method name to call on +parent+ when the button is released
	# * *Returns*:
	#   - a Gtk::Button
	def ButtonCreator.main(name: nil, clicked: nil, released: nil, parent: nil)
		ButtonCreator.new(
				:name => name, 
				:clicked => clicked, 
				:released => released, 
				:parent => parent, 
				:relief => true
		)
	end

end
