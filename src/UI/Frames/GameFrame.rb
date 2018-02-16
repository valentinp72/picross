require_relative '../Frame'

require_relative '../../Map'

class GameFrame < Frame

	def initialize(map)
		super()
		@area = Gtk::DrawingArea.new
		@grid = map.solution
		setGame()

		@area.signal_connect('button_press_event') do |draw, button|
#print "click '#{button.y}, #{button.x}' \n"
			gridPosY = (button.y / @cellSize * 1000).floor / 1000.0
			gridPosX = (button.x / @cellSize * 1000).floor / 1000.0
			cell = @grid.getCellPosition(gridPosY, gridPosX)
			cell.stateRotate
			@wantedState = cell.state
			puts @wantedState
#print @grid
			@area.queue_draw
#userClickedAt(button.y, button.x)
		end

		@area.signal_connect('motion_notify_event') do |draw, motionEvent|#draw, button|
			if motionEvent.state.button1_mask? then
				# on a bougé en cliquant
#print "click '#{motionEvent.y / @cellSize}, #{motionEvent.x / @cellSize}' \n"
				userClickedAt(motionEvent.y, motionEvent.x)
			end
		end

		@area.events |= (Gdk::EventMask::BUTTON_PRESS_MASK |
		                 Gdk::EventMask::POINTER_MOTION_MASK)

		@lastClickedX = nil
		@lastClickedY = nil
		@wantedState  = Cell::CELL_CROSSED
	end

	def userClickedAt(yPos, xPos)
		gridPosY = (yPos / @cellSize * 1000).floor / 1000.0
		gridPosX = (xPos / @cellSize * 1000).floor / 1000.0
		if gridPosX != @lastClickedX || gridPosY != @lastClickedY then
			begin
				@grid.getCellPosition(gridPosY, gridPosX).state = @wantedState
				@area.queue_draw
				@lastClickedY = gridPosY
				@lastClickedX = gridPosX
			rescue
				print "Invalid position"
			end
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
	end

end
