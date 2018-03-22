require_relative '../../AssetsLoader'

##
# File          :: Drag.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/06/2018
# Last update   :: 03/08/2018
# Version       :: 0.1
#
# This class is an helper allowing to change the cursor of a given window, 
# either to the defaut one, either to one with a text.

class CursorHelper

	# The default cursror to display when reseting the cursror
	DEFAULT_CURSOR = Gdk::Cursor.new("default")

	##
	# Creation of a new cursor helper on a window.  
	# The cusror of the given window is first reseted to the default one.
	# * *Arguments* :
	#   - +window+ -> the window this helper will be operating on
	def initialize(window)
		@window = window
		self.reset
	end

	##
	# Resets the cursor of the window this helper is about.
	# * *Returns* :
	#   - the helper itself
	def reset()
		@window.set_cursor(DEFAULT_CURSOR)
		return self
	end

	##
	# Sets a text on the cursor of the window the helper is about.
	# * *Arguments* :
	#   - +text+ -> the text to display on the cursor
	# * *Returns* :
	#   - the helper itself
	def setText(text)
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

		return self
	end

	##
	# Draw some text on the Cairo::Context at a given position.
	# * *Arguments* :
	#   - +cr+     -> the Cairo::Context to display the text on
	#   - +text+   -> the text to display
	#   - +xStart+ -> the X position to start the text
	#   - +yStart+ -> the Y position to start the text
	# * *Returns* :
	#   - the helper itself
	def drawText(cr, text, xStart, yStart)
		cr.font_size = 15
		cr.source_color = Gdk::Color.parse("#1401aa")
		cr.move_to xStart, yStart
		cr.show_text text
		return self
	end

	##
	# Draw a background color on the given Cairo::Context on the specified area.
	# * *Arguments* :
	#   - +cr+     -> the Cairo::Context to display the text on
	#   - +xStart+ -> the X position to start the background color
	#   - +xEnd+   -> the X position to end the background color
	#   - +yStart+ -> the Y position to start the background color
	#   - +yEnd+   -> the Y position to end the background color
	# * *Returns* :
	#   - the helper itself 
	def drawBackground(cr, xStart, xEnd,  yStart, yEnd)
		margin = 5
		cr.source_rgba = 1.0, 1.0, 1.0, 0.8
		cr.rectangle xStart - margin / 2, margin / 2, Integer(xEnd - xStart) + margin, 20 + margin 
		cr.fill
		return self
	end

end
