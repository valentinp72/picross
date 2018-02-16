require_relative '../Frame'

require_relative '../../Map'
require_relative '../../Cell'

class GameFrame < Frame

	def initialize(map)
		super()
		@area = Gtk::DrawingArea.new
		@grid = map.solution
		setGame()

		@area.signal_connect('button_press_event') do |draw, button|
			gridPosY, gridPosX = getPositions(button.y, button.x)
			if gridPosY != nil and gridPosX != nil then
				print "#{gridPosY}, #{gridPosX}\n"
				cell = @grid.getCellPosition(gridPosY, gridPosX)
				print cell
				if button.button == 1 then
					cell.stateRotate
				else
					cell.state = Cell::CELL_CROSSED
				end
				puts cell
				@wantedState = cell.state
				@area.queue_draw
				@lastClickedY = gridPosY
				@lastClickedX = gridPosX
			end
		end

		@area.signal_connect('motion_notify_event') do |draw, motionEvent|
			if motionEvent.state.button1_mask? || motionEvent.state.button2_mask? then
				# on a bougé en cliquant
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
		gridPosY, gridPosX = getPositions(yPos, xPos)
		if gridPosY != nil and gridPosX != nil then
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
	end

end
