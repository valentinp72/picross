require_relative '../../AssetsLoader.rb'

##
# File          :: CellButton.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/23/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class represents a clickable cell in a Picross.
# A clickable cell is a GTK EventBox, and it's composed of a Cell.

class CellButton < Gtk::EventBox

	# The real Cell that this button is composed
	attr_reader :cell

	# Left-click value when a button-click event is throwed
	BUTTON_LEFT_CLICK  = 1

	# Right-click value when a button-click event is throwed
	BUTTON_RIGHT_CLICK = 3

	# The image of the black cell
	BLACK_PIXBUF = AssetsLoader.loadPixbuf('black_cell.png')
	# The image of the while cell
	WHITE_PIXBUF = AssetsLoader.loadPixbuf('white_cell.png')
	# The image of the cell when crossed
	CROSS_PIXBUF = AssetsLoader.loadPixbuf('cross_cell.png')

	# The default size of the cells
	DEFAULT_SIZE = 20
	@@BLACK_PIXBUF = BLACK_PIXBUF.scale(DEFAULT_SIZE, DEFAULT_SIZE)
	@@WHITE_PIXBUF = WHITE_PIXBUF.scale(DEFAULT_SIZE, DEFAULT_SIZE)
	@@CROSS_PIXBUF = CROSS_PIXBUF.scale(DEFAULT_SIZE, DEFAULT_SIZE)

	##
	# Creation of a new CellButton
	# * *Arguments* :
	#   - +cell+      -> the real picross Cell
	#   - +drag+      -> a Drag object, allowing this cell to drag multiple cells
	#   - +colorsHyp+ -> the colors to display according to the hypotheses
	def initialize(cell, drag, colorsHyp, picross)
		super()
		@cell  = cell
		@drag  = drag
		@colorsHyp = colorsHyp
		@picross = picross

		# The content of this cell is just a blank image
		@widget = Gtk::Image.new()

		# Add the CSS to the button
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: self.css)
		@style_context = @widget.style_context
		@style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
		@widget.visible = true

		self.setEvents
		self.setAttributes
		self.add(@widget)
	end

	##
	# Asks the class to resize the images to be used by the instances
	# * *Arguments* :
	#   - +width+  -> the future width of the images
	#   - +height+ -> the future height of the images
	# * *Returns* :
	#   - the object itself
	def CellButton.resize(width, height)
		@@BLACK_PIXBUF = BLACK_PIXBUF.scale(width, height)
		@@WHITE_PIXBUF = WHITE_PIXBUF.scale(width, height)
		@@CROSS_PIXBUF = CROSS_PIXBUF.scale(width, height)
		return self
	end

	##
	# Resises the cell to the size that is currently set on
	# the images, using +CellButton.resize(width, height)+.
	# * *Returns* :
	#   - the object itself
	def resize()
		@widget.pixbuf = choosePixbufState
		return self
	end

	##
	# Sets the new Cell of the button
	# * *Arguments* :
	#   - +newCell+ -> the new Cell to be set
	# * *Returns* :
	#   - the CellButton itself
	def cell=(newCell)
		@cell = newCell
		self.setAttributes
		return self
	end

	##
	# Create the events of the CellButton.
	# This add the events to allow changing cell state,
	# and to drag between several cells
	# * *Returns* :
	#   - the CellButton itself
	def setEvents()
		self.events |= (
			Gdk::EventMask::BUTTON_PRESS_MASK |
			Gdk::EventMask::BUTTON_RELEASE_MASK |
			Gdk::EventMask::ENTER_NOTIFY_MASK |
			Gdk::EventMask::LEAVE_NOTIFY_MASK)

		self.signal_connect('button_press_event') do |widget, event|
			self.buttonPress(event.button)
		end

		self.signal_connect('button_release_event') do |widget, event|
			self.buttonUnpress()
		end

		self.signal_connect('enter_notify_event') do |widget, event|
			self.enterNotify()
		end

		self.signal_connect('leave_notify_event') do |widget, event|
			self.leaveNotify()
		end

		return self
	end

	##
	# Updates the css attributes of the cell to be exaclty what
	# the cells is, and the button itself (state and hypothesis)
	# * *Returns* :
	#   - the CellButton itself
	def setAttributes()
		wantedClasses = []

		# chooses the class about the hypothesis of the cell
		wantedClasses.push(chooseHypothesisClass)

		# chooses the pixbuf about the state of the cell
		@widget.pixbuf = choosePixbufState

		@style_context.classes.each do |className|
			@style_context.remove_class(className)
		end
		wantedClasses.each do |className|
			@style_context.add_class(className)
		end
		return self
	end

	##
	# Returns a CSS class name according to the current state of the cell
	# * *Returns* :
	#   - +black+, +crossed+ or +white+ according to the state
	def choosePixbufState()
		case @cell.state
			when Cell::CELL_BLACK
				return @@BLACK_PIXBUF
			when Cell::CELL_CROSSED
				return @@CROSS_PIXBUF
		end
		return @@WHITE_PIXBUF
	end

	##
	# Returns a CSS class name according to the current cell hypothesis
	# * *Returns* :
	#   - +hypX+ where X is the hypothesis id, or +hypUnknown+ if the hypothesis is unknown
	def chooseHypothesisClass()
		if @cell.hypothesis.id >= 0 && @cell.hypothesis.id <= 4 then
			return "hyp#{@cell.hypothesis.id}"
		end
			return "hypUnknown"
	end

	##
	# Returns the needed CSS for the image of a button cell, it's state and hypothesis
	# * *Returns* :
	#   - a String containing the CSS
	def css()
		"
			/* Main definition */
			image {
				border-left: 1px solid gray;
				border-top : 1px solid gray;
				#{
					if @cell.posX % 5 == 0 then
						'border-left-width: 4px;'
					end
				}
				#{
					if @cell.hypothesis.grid.columns - 1 == @cell.posX then
						'border-right: 4px solid gray;'
					end
				}
				#{
					if @cell.hypothesis.grid.lines - 1 == @cell.posY then
						'border-bottom: 4px solid gray;'
					end
				}
				#{
					if @cell.posY % 5 == 0 then
						'border-top-width : 4px;'
					end
				}
			}

			/* Hypotheses */
			.hyp0 {
				background-color: #{@colorsHyp[0]};
			}
			.hyp1 {
				background-color: #{@colorsHyp[1]};
			}
			.hyp2 {
				background-color: #{@colorsHyp[2]};
			}
			.hyp3 {
				background-color: #{@colorsHyp[3]};
			}
			.hyp4 {
				background-color: #{@colorsHyp[4]};
			}
			.hypUnknown {
				border-color    : red;
				background-color: red;
			}
		"
	end

	def clean()
		self.parent.parent.parent.unsetHover(
				@picross.keyboard.posX, 
				@picross.keyboard.posY
		)
		@picross.keyboard.posX = @cell.posX
		@picross.keyboard.posY = @cell.posY
	end

	def enterNotify()
		self.clean()
		@drag.update(@cell)
		self.parent.parent.parent.setHover(@cell.posX, @cell.posY)
		self.setAttributes
	end

	def leaveNotify()
		self.clean()
		# il devrait aussi avoir un update ici en principe
		@drag.update(@cell)
		self.parent.parent.parent.unsetHover(@cell.posX, @cell.posY)
		self.setAttributes
	end

	def buttonPress(event)
		self.clean()

		# force to not grab focus on current button
		Gdk.pointer_ungrab(Gdk::CURRENT_TIME)

		if event == BUTTON_LEFT_CLICK then
			@drag.startLeftDrag(@cell)
		elsif event == BUTTON_RIGHT_CLICK then
			@drag.startRightDrag(@cell)
		end

		self.setAttributes
	end

	def buttonUnpress()
		self.clean()

		@drag.reset
	end

end
