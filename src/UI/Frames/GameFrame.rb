require_relative '../Frame'

require_relative '../../Map'
require_relative '../../Cell'
require_relative '../../Drag'


class PicrossFrame < Frame
	
	BUTTON_LEFT_CLICK  = 1
	BUTTON_RIGHT_CLICK = 3 

	def initialize(grid)
		super()
		@grid = grid
		self.label = "PicrossFrame"

#	puts self.methods
#		print self.realize
#:		print self.allocated_size

#		self.set_size_request(100, 100)
		createArea()
	end

	def createArea()
		@area = Gtk::DrawingArea.new
		@drag = nil
		

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
		
		setGame()
		return @area
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
			allowedW = 00#self.parent.width_request
			allowedH = 00#self.parent.height_request

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

class GameFrame < Frame


	def initialize(map)
		super()
		self.border_width = 10
		self.label = "GameFrame"
		@grid = map.solution
		@map  = map

		self.createMainLayout

#
#		self.signal_connect('size-allocate') do 
#			print 'h'
#			print self.parent.queue_draw
			#self.queue_draw
#		end
		@main.show_all
	end


	def createMainLayout()
	
		@header  = createHeaderLayout()
		@content = createContentLayout() 

		@main = Gtk::Box.new(:vertical, 2)
		@main.pack_start(@header)
		@main.pack_start(@content, :expand => true, :fill => true)

		self.add(@main)
#self.set_size_request(500, 500)
	end

	def createHeaderLayout()
	
		btnBack   = Gtk::Button.new(:label => "Back")
		title     = Gtk::Label.new(@map.name)
		btnOption = Gtk::Button.new(:label => "Options")

		@header = Gtk::Box.new(:horizontal)
		@header.pack_start(btnBack,   :expand => true, :fill => true)
		@header.pack_start(title,     :expand => true, :fill => true)
		@header.pack_start(btnOption, :expand => true, :fill => true)
	
		return @header
	end

	def createContentLayout()

		
		@content = Gtk::Box.new(:horizontal)
#		@content.set_size_request(600, 600)
		
		@picross = PicrossFrame.new(@grid)
		@sideBar = createSideBarLayout()

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar)

		return @content
	end

	def createSideBarLayout()

		@timer = Gtk::Label.new("Timer")
		@reset = Gtk::Button.new(:label => "Reset")
		@pause = Gtk::Button.new(:label => "Pause")
		@hypot = Gtk::Button.new(:label => "Hypotheses")
		@help  = Gtk::Button.new(:label => "Help")

		@sideBar = Gtk::Box.new(:vertical)
		@sideBar.pack_start(@timer, :expand => true, :fill => true)
		@sideBar.pack_start(@reset, :expand => true, :fill => true)
		@sideBar.pack_start(@pause, :expand => true, :fill => true)
		@sideBar.pack_start(@hypot, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

end
