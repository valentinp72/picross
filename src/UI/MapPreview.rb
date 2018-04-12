require_relative 'AssetsLoader'

##
# File          :: MapPreview.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/04/2018
# Last update   :: 04/04/2018
# Version       :: 0.1
#
# This module allow the create of a Gtk::Image previewing an image of a map.

module MapPreview

	##
	# Create an return a Gtk::Image showing a preview of the Map
	# in it's current state.
	# * *Arguments* :
	#   - +map+ -> the Map to show
	#   - +totalWidth+ -> the total allowed width for this image
	#   - +totalHeight+ -> the total allowed height for this image
	# * *Returns* :
	#   - a Gtk::Image with a representation of the Map
	def MapPreview.image(map, totalWidth, totalHeight)
		grid    = map.grid
		surface = Cairo::ImageSurface.new(totalWidth, totalHeight)
		cr      = Cairo::Context.new(surface)

		width   = totalWidth  / grid.columns
		height  = totalHeight / grid.lines

		grid.each_cell_with_index do |cell, line, column|
			if cell.state == Cell::CELL_BLACK then
				cr.set_source_rgba(0.0, 0.0, 0.0, 1.0)
			else
				cr.set_source_rgba(1.0, 1.0, 1.0, 0.0)
			end
			cr.rectangle(column * width, line * height, width, height)
			cr.fill
		end

		pixBuf = AssetsLoader.pixbufFromSurface(surface)
		return AssetsLoader.imageFromPixbuf(pixBuf)
	end

end
