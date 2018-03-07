require_relative '../../AssetsLoader'

class CursorHelper

	DEFAULT_CURSOR = Gdk::Cursor.new("default")

	def initialize(window)
		@window = window
		self.reset
	end

	def reset()
		@window.set_cursor(DEFAULT_CURSOR)
	end

	def setValues(firstV, secondV)
		text    = "#{firstV} | #{secondV}"
		surface = Cairo::ImageSurface.new(:argb32, 100, 100)
		cr      = Cairo::Context.new(surface)

		# the little cross indicating the mouse
		cr.source_color = Gdk::Color.parse("#888888")
        cr.rectangle 5, 0, 1, 10
        cr.rectangle 0, 5, 10, 1
		cr.fill

		xStart = 20
		yStart = 20
		
		# we draw the text for the first time (to get it's size)
		self.drawText(cr, text, xStart, yStart)
		
		xEnd, yEnd = cr.current_point

		# we apply a background where the text has been printed
		self.drawBackground(cr, xStart, xEnd, yStart, yEnd)
		
		# we draw back the text, because the background has overwritten it
		self.drawText(cr, text, xStart, yStart)
		
		pixbuf = AssetsLoader.pixbufFromSurface(surface)
		cursor = Gdk::Cursor.new(pixbuf, 5, 5)
		@window.cursor = cursor
	end

	def drawText(cr, text, xStart, yStart)
		cr.font_size = 15
		cr.source_color = Gdk::Color.parse("#1401aa")
		cr.move_to xStart, yStart
		cr.show_text text
	end

	def drawBackground(cr, xStart, xEnd,  yStart, yEnd)
		margin = 5
		cr.source_rgba = 1.0, 1.0, 1.0, 0.8
		cr.rectangle xStart - margin / 2, margin / 2, Integer(xEnd - xStart) + margin, 20 + margin 
		cr.fill
	end

end
