##
# File          :: GridCreator.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/25/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
#
# This module helps to create Gtk::Grids from arrays of widgets

module GridCreator

	def GridCreator.fromArray(array, horizontal: false, vertical: false)
		if horizontal == false && vertical == false then
			vertical = true
		end
		grid = Gtk::Grid.new

		grid.row_spacing = 5
		grid.halign = Gtk::Align::CENTER
		grid.valign = Gtk::Align::CENTER
		x = 0
		y = 0
		array.each_index do |i|
			y = i if vertical
			x = i if horizontal
			grid.attach(array[i], x, y, 1, 1)
		end

		return grid
	end

end
