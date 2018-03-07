require_relative '../../AssetsLoader'

class CursorHelper

	DEFAULT_CURSOR = Gdk::Cursor.new("default")
	
	CHARS = [AssetsLoader.loadPixbuf('cursor/0.png'), 
	         AssetsLoader.loadPixbuf('cursor/1.png'),
			 AssetsLoader.loadPixbuf('cursor/2.png'),
			 AssetsLoader.loadPixbuf('cursor/3.png'), 
			 AssetsLoader.loadPixbuf('cursor/4.png'), 
			 AssetsLoader.loadPixbuf('cursor/5.png'), 
			 AssetsLoader.loadPixbuf('cursor/6.png'), 
			 AssetsLoader.loadPixbuf('cursor/7.png'), 
			 AssetsLoader.loadPixbuf('cursor/8.png'), 
			 AssetsLoader.loadPixbuf('cursor/9.png')
			] 

	def initialize(window)
		@window = window
		self.reset
	end

	def reset()
		@window.set_cursor(DEFAULT_CURSOR)
	end

	def setValues(firstV, secondV)
		surface = Cairo::ImageSurface.new(:argb32, 100, 100)
		cr = Cairo::Context.new(surface)
		
		cr.set_source_rgb 0.0, 0.0, 0.0
        cr.rectangle 5, 0, 1, 10
        cr.rectangle 0, 5, 10, 1
		cr.fill

		cr.set_source_rgb 0.7, 0.08, 0.0
		cr.set_font_size 15 
		cr.move_to 10, 10
		cr.show_text "#{firstV} / #{secondV}"
		
		pixbuf = AssetsLoader.pixbufFromSurface(surface)
		cursor = Gdk::Cursor.new(pixbuf, 5, 5)
		@window.cursor = cursor
	end

end
