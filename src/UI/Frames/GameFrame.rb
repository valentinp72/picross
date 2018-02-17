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
				print button.button, "\n"
				if button.button == 1 then
					print "on rotate la cell\n"
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
		@hbox.pack_start(@area, :expand => true, :fill => true, :padding =>2)
		#@hbox.pack_start(@vbox2, :expand => true, :fill => true, :padding =>2)

		# Add vertical box containing 2 boxes
		@vbox = Gtk::Box.new(:vertical, 2)
		@vbox.pack_start(@hbox2, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)
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
		#add(@vbox)
	end

end
