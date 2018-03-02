class AssetsLoader

	def AssetsLoader.loadImage(asset_name, width = nil, height = nil)
		begin
			pixbuf = AssetsLoader.loadPixbuf(asset_name) 
			
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
			image  = AssetsLoader.imageFromPixbuf(pixbuf)
			return image
		rescue	
			return Gtk::Image.new
		end
	end

	def AssetsLoader.loadPixbuf(asset_name)
		file = AssetsLoader.loadFile(asset_name)
		return GdkPixbuf::Pixbuf.new(:file => file)
	end

	def AssetsLoader.imageFromPixbuf(pixbuf)
		if not pixbuf.kind_of?(GdkPixbuf::Pixbuf) then
			return Gtk::Image.new
		end
		return Gtk::Image.new(:pixbuf => pixbuf)
	end

	def AssetsLoader.cloneImage(image)
		if not image.kind_of?(Gtk::Image) then
			return Gtk::Image.new
		end
		return Gtk::Image.new(:pixbuf => image.pixbuf)
	end

	def AssetsLoader.loadFile(asset_name)
		return File.expand_path(File.dirname(__FILE__) + "/assets/" + asset_name)
	end

end
