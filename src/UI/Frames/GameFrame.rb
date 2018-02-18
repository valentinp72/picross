require_relative '../Frame'

require_relative '../../Map'
require_relative '../../Cell'


class Drag

	# @startPosition
	# @lastPosition

	def initialize(grid, yPos, xPos, shouldCross=false)
		@grid = grid
		
		@yStart = yPos
		@xStart = xPos
		@yLast  = yPos
		@xLast  = xPos

		cell = @grid.getCellPosition(yPos, xPos)
		if shouldCross then
			cell.stateInvertCross
		else
			cell.stateRotate
		end
		@newState = cell.state
		sleep 0.001
	end

	def validPosition?(yPos, xPos)
		return yPos != nil || xPos != nil
	end

	def update(yNew, xNew)
		if validPosition?(yNew, xNew) then
			if yNew != @yLast || xNew != @xLast then

				if xNew == @xStart then
					# vertical line
					ys = [@yStart, yNew]
					ys.min.upto(ys.max) do |y|
						self.cellUpdate(y, @xStart)
					end
				elsif yNew == @yStart then
					# horizontal line
					xs = [@xStart, xNew]
					xs.min.upto(xs.max) do |x|
						self.cellUpdate(@yStart, x)
					end
				end

				@yLast = yNew
				@xLast = xNew
			end
		end
	end

	def cellUpdate(yPos, xPos)
		@grid.getCellPosition(yPos, xPos).state = @newState
	end

end

class GameFrame < Frame

	BUTTON_LEFT_CLICK  = 1
	BUTTON_RIGHT_CLICK = 3 

	def initialize(map)
		super()
		@area = Gtk::DrawingArea.new
		@grid = map.solution
		@drag = nil
		
		setGame()
		createLayout()

		@area.events |= (Gdk::EventMask::BUTTON_PRESS_MASK |
						 Gdk::EventMask::BUTTON_RELEASE_MASK |
		                 Gdk::EventMask::POINTER_MOTION_MASK |
						 Gdk::EventMask::POINTER_MOTION_HINT_MASK)


		@area.signal_connect('button_press_event') do |widget, event|
			gridPosY, gridPosX = getPositions(event.y, event.x)
			if event.button == BUTTON_LEFT_CLICK then
				@drag = Drag.new(@grid, gridPosY, gridPosX)
			elsif event.button == BUTTON_RIGHT_CLICK then
				@drag = Drag.new(@grid, gridPosY, gridPosX, true)
			end
			@area.queue_draw
		end

		@area.signal_connect('button_release_event') do |widget, event|
			@drag = nil
		end
		
		@area.signal_connect('motion_notify_event') do |widget, event|
			if event.state.button1_mask? || event.state.button3_mask? then
				gridPosY, gridPosX = getPositions(event.y, event.x)
				if @drag != nil then
					@drag.update(gridPosY, gridPosX)			
					@area.queue_draw
				end
			end
		end

	end

	def createLayout()
		# Add label
		@label1 = Gtk::Label.new("Label 1")
		@label2 = Gtk::Label.new("Label 2")
		@label3 = Gtk::Label.new("Label 3")

		# Add horizontal box containing 3 boxes
		@hbox2 = Gtk::Box.new(:horizontal, 3)
		@hbox2.pack_start(@label1, :expand => true, :fill => true, :padding =>2)
		@hbox2.pack_start(@label2, :expand => true, :fill => true, :padding =>2)
		@hbox2.pack_start(@label3, :expand => true, :fill => true, :padding =>2)

		# Add label
		@label4 = Gtk::Label.new("Label 4")
		@label5 = Gtk::Label.new("Label 5")
		@label6 = Gtk::Label.new("Label 6")

		# Add vertical box containing 3 boxes
		@vbox2 = Gtk::Box.new(:vertical, 3)
		@vbox2.pack_start(@label4, :expand => true, :fill => true, :padding =>2)
		@vbox2.pack_start(@label5, :expand => true, :fill => true, :padding =>2)
		@vbox2.pack_start(@label6, :expand => true, :fill => true, :padding =>2)

		# Add horizontal box containing 2 boxes
		@hbox = Gtk::Box.new(:horizontal, 2)
#@hbox.pack_start(@area, :expand => true, :fill => true, :padding =>2)
		#@hbox.pack_start(@vbox2, :expand => true, :fill => true, :padding =>2)

		# Add vertical box containing 2 boxes
		@vbox = Gtk::Box.new(:vertical, 2)
		@vbox.pack_start(@hbox2, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)
	end

	def getPositions(yFramePosition, xFramePosition)
		gridPosY = (yFramePosition / @cellSize).floor
		gridPosX = (xFramePosition / @cellSize).floor

		if @grid.validPosition?(gridPosY, gridPosX) then
			return [gridPosY, gridPosX]
		else
			return nil
		end
	end

	def setGame()

		@area.signal_connect "draw" do
			cr = @area.window.create_cairo_context
			# GDK_comma
			allowedW = self.parent.width_request
			allowedH = self.parent.height_request

			sizeX_tmp = allowedW / @grid.columns
			sizeY_tmp = allowedH / @grid.lines

			@cellSize = [sizeX_tmp, sizeY_tmp].min

			@grid.each_cell_with_index do |cell, j, i|
				posX = i * @cellSize
				posY = j * @cellSize

				case cell.state
					when Cell::CELL_BLACK
						cr.set_source_rgb 0.0, 0.0, 0.0
					when Cell::CELL_WHITE
						cr.set_source_rgb 1.0, 1.0, 1.0
					when Cell::CELL_CROSSED
						cr.set_source_rgb 0.8, 0.8, 0.8
					else
						cr.set_source_rgb 1.0, 0.0, 0.0
				end

				cr.rectangle(posX, posY, @cellSize, @cellSize)
				cr.fill
			end

		end

		@area.show
		add(@area)
		#add(@vbox)
	end

end
