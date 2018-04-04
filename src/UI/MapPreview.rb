require_relative 'AssetsLoader'

module MapPreview

	def MapPreview.image(map, totalWidth, totalHeigth)
		grid    = map.grid
		surface = Cairo::ImageSurface.new(totalWidth, totalHeigth)
		cr      = Cairo::Context.new(surface)

		width   = totalWidth  / grid.columns
		height  = totalHeigth / grid.lines

		grid.each_cell_with_index do |cell, line, column|
			if cell.state == Cell::CELL_BLACK then
				cr.rectangle(column * width, line * height, width, height)
				cr.fill
			end
		end

		pixBuf = AssetsLoader.pixbufFromSurface(surface)
		return AssetsLoader.imageFromPixbuf(pixBuf)
	end

end
