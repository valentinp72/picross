##
# File          :: AssetsLoader.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/24/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
#
# This module helps to load images and pixbuf for the game. All images
# that needs to be load by this module needs to be put in the +assets/+ folder.

module AssetsLoader

	##
	# Load a Gtk::Image from an asset name. You can optionally resize the image
	# to a given width and/or height. The image will however keep it's ratio, 
	# even if the given width and height break the image proportions.
	# If the asset could not be found, this returns a blank image.
	# * *Arguments* :
	#   - +asset_name+ -> the name of the image inside the +assets+ folder, including the extension
	#   - +width+      -> optional width of the image to resize it
	#   - +height+     -> optional height of the image to resize it
	# * *Returns* :
	#   - a Gtk::Image of the given asset name
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

	##
	# Returns a GdkPixbuf::Pixbuf corresponding for the given asset name in the assets folder.
	# * *Arguments* :
	#   - +asset_name+ -> the name of the asset to load
	# * *Returns* :
	#   - a GdkPixbuf::Pixbuf with the given asset
	def AssetsLoader.loadPixbuf(asset_name)
		file = AssetsLoader.loadFile(asset_name)
		return GdkPixbuf::Pixbuf.new(:file => file)
	end

	##
	# Returns a GdkPixbuf::Pixbuf from a given surface (Cairo::Surface)
	# * *Arguments* :
	#   - a surface (like Cairo::ImageSurface)
	# * *Returns* :
	#   - a GdkPixbuf::Pixbuf from the surface
	def AssetsLoader.pixbufFromSurface(surface)
		return GdkPixbuf::Pixbuf.new(
				:data => surface.data, 
				:width => surface.width, 
				:height => surface.height, 
				:row_stride => surface.stride, 
				:colorspace => :rgb, 
				:has_alpha => true
		)
	end

	##
	# Create a Gtk::Image from a given pixbuf. If the pixbuf is not valid, returns
	# a blank image.
	# * *Arguments* :
	#   - +pixbuf+ -> a pixbuf to convert to an image
	# * *Returns* :
	#   - a Gtk::Image from the pixbuf
	def AssetsLoader.imageFromPixbuf(pixbuf)
		if not pixbuf.kind_of?(GdkPixbuf::Pixbuf) then
			return Gtk::Image.new
		end
		return Gtk::Image.new(:pixbuf => pixbuf)
	end

	##
	# Clone a Gtk::Image from a given Gtk::Image
	# If the given image is not valid, this returns a blank image.
	# * *Arguments* :
	#   - +image+ -> the image to clone
	# * *Returns* :
	#   - a copy of the given Gtk::Image
	def AssetsLoader.cloneImage(image)
		if not image.kind_of?(Gtk::Image) then
			return Gtk::Image.new
		end
		return Gtk::Image.new(:pixbuf => image.pixbuf)
	end

	##
	# Returns the real path of an asset in the +assets/+ folder.
	# * *Arguments* :
	#   - +asset_name+ -> the asset to get it's real path
	# * *Returns* :
	#   - a String with the full path of the asset in the project
	def AssetsLoader.loadFile(asset_name)
		return File.expand_path(File.dirname(__FILE__) + "/assets/" + asset_name)
	end

end
