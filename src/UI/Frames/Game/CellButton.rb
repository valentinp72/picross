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

	# Left-click value when a button-click event is throwed
	BUTTON_LEFT_CLICK  = 1

	# Right-click value when a button-click event is throwed
	BUTTON_RIGHT_CLICK = 3

	# The real Cell that this button is composed
	attr_reader :cell
	attr_writer :cell

	BLACK_PIXBUF = AssetsLoader.loadPixbuf('black_cell.png')
	WHITE_PIXBUF = AssetsLoader.loadPixbuf('white_cell.png')
	CROSS_PIXBUF = AssetsLoader.loadPixbuf('cross_cell.png')

	##
	# Creation of a new CellButton
	# * *Arguments* :
	#   - +cell+ -> the real picross Cell
	#   - +drag+ -> a Drag object, allowing this cell to drag multiple cells
	def initialize(cell, drag)
		super()
		@cell  = cell
		@drag  = drag

		# The content of this cell is just a blank image
		@widget = Gtk::Image.new()

		# Add the CSS to the button
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: self.css)
		@widget.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

		self.setEvents
		self.setAttributes
		self.add(@widget)
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

			# force to not grab focus on current button
			Gdk.pointer_ungrab(Gdk::CURRENT_TIME)

			if event.button == BUTTON_LEFT_CLICK then
				@drag.startLeftDrag(@cell)
			elsif event.button == BUTTON_RIGHT_CLICK then
				@drag.startRightDrag(@cell)
			end

			self.setAttributes
		end

		self.signal_connect('button_release_event') do |widget, event|
			@drag.reset
		end

		self.signal_connect('enter_notify_event') do |widget, event|
			@drag.update(@cell)
			self.setAttributes
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

		@widget.style_context.classes.each do |className|
			@widget.style_context.remove_class(className)
		end
		wantedClasses.each do |className|
			@widget.style_context.add_class(className)
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
				return BLACK_PIXBUF
			when Cell::CELL_CROSSED
				return CROSS_PIXBUF
		end
		return WHITE_PIXBUF
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
				/*border-color: black;*/
				background-color: black;
			}
			.hyp1 {
				/*border-color: red;*/
				background-color: red;
			}
			.hyp2 {
				/*
				border-color: green;*/
				background-color: green;
			}
			.hyp3 {
				/* border-color: yellow;*/
				background-color: yellow;
			}
			.hyp4 {
				/*
				border-color: blue;
				*/
				background-color: blue;
			}
			.hypUnknown {
				border-color    : red;
				background-color: red;
			}
		"
	end

end
