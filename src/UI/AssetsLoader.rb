class AssetsLoader

	def AssetsLoader.loadImage(asset_name, width = nil, height = nil)
		file = AssetsLoader.loadFile(asset_name)
	

		begin
			pixbuf = GdkPixbuf::Pixbuf.new(:file => file)
			
			newHeight = height == nil ? pixbuf.height : height
			newWidth  = width  == nil ? pixbuf.width  : width

			wRatio = pixbuf.width  / newWidth
			hRatio = pixbuf.height / newHeight

			if wRatio > hRatio then
				newHeight = pixbuf.height / wRatio 
			else
				newWidth  = pixbuf.width  / hRatio
			end

			pixbuf = pixbuf.scale(newWidth, newHeight)
			image  = Gtk::Image.new(:pixbuf => pixbuf)
			return image
		rescue	
			return Gtk::Image.new()
		end
	end

	def AssetsLoader.loadFile(asset_name)
		return File.expand_path(File.dirname(__FILE__) + "/assets/" + asset_name)
	end

end
