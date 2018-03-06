require_relative '../../AssetsLoader'

class CursorHelper

	DEFAULT_CURSOR = Gdk::Cursor.new(Gdk::CursorType::LEFT_PTR)

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
		print CHARS[0].methods

	def initialize(window)
		@window = window
		self.reset
	end

	def reset()
		@window.set_cursor(DEFAULT_CURSOR)
	end

	def setValues(firstV, secondV)
		cursor = Gdk::Cursor.new(AssetsLoader.loadPixbuf("mouse-drag.png"), 5, 5)
		@window.set_cursor(cursor)
	end

end
