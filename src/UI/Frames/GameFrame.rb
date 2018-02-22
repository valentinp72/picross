require_relative '../Frame'

require_relative '../../Map'
require_relative '../../Cell'
require_relative '../../Drag'

class CellButton < Gtk::EventBox

	BUTTON_LEFT_CLICK  = 1
	BUTTON_RIGHT_CLICK = 3 

	attr_reader :cell

	def initialize(cell, drag, cells)
		super()
		@cell  = cell
		@drag  = drag
		@cells = cells

		@surface = Cairo::ImageSurface.new(:argb32, 20, 20)
		@widget  = Gtk::Image.new(:surface => @surface)
		
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: "
			image {
				background-color: red;
				border: 1px solid black;
			}
			.activated {
				background-color: black;
			}
			.crossed {
				background-color: gray;
			}
			.white {
				background-color: white;
			}
		")
		@widget.style_context.add_provider(
				css_provider, 
				Gtk::StyleProvider::PRIORITY_USER
		)

		self.events |= (
			Gdk::EventMask::BUTTON_PRESS_MASK |
			Gdk::EventMask::BUTTON_RELEASE_MASK |
			Gdk::EventMask::ENTER_NOTIFY_MASK |
			Gdk::EventMask::LEAVE_NOTIFY_MASK)

		self.signal_connect('button_press_event') do |widget, event|
			
			# force to not grab focus on current button
			Gdk.pointer_ungrab(Gdk::CURRENT_TIME)

			puts "je suis la cell #{@cell} : #{@cell.posX}, #{@cell.posY}"

			if event.button == BUTTON_LEFT_CLICK then
				@drag.startLeftDrag(@cell)
			elsif event.button == BUTTON_RIGHT_CLICK then
				@drag.startRightDrag(@cell)
			end

			self.setCSSClass

		end

		self.signal_connect('button_release_event') do |widget, event|
			@drag.reset
		end

		self.signal_connect('enter_notify_event') do |widget, event|
			@drag.update(@cell)
			@drag.changedCells.each do |toUpdateCell|
				toUpdateCell.state = @drag.wantedCell
				cells.get_child_at(toUpdateCell.posX, toUpdateCell.posX).setCSSClass
			end
			self.setCSSClass
		end

		self.signal_connect('leave_notify_event') do |widget, event|
		end

		self.setCSSClass()
		self.add(@widget)

	end

	def setCSSClass()
		puts "Je suis la cell #{@cell.posX}, #{@cell.posY}, #{@cell.state}"
		wantedClass = ""
		if @cell.state == Cell::CELL_BLACK then
			wantedClass = "activated"
		elsif @cell.state == Cell::CELL_CROSSED then
			wantedClass = "crossed"
		else
			wantedClass = "white"
		end

		gotIt = false
		@widget.style_context.classes.each do |className|
			if not className == wantedClass then
				@widget.style_context.remove_class(className)
			else
				gotIt = true
			end
		end
		if not gotIt then
			@widget.style_context.add_class(wantedClass)
		end
	end

end

class PicrossFrame < Frame
	
	def initialize(grid)
		super()
		self.border_width = 20
		@grid = grid
		@drag = Drag.new

		createArea()
	end

	def createArea()
		@cells = Gtk::Grid.new

		@grid.each_cell_with_index do |cell, line, column|
			@cells.attach(CellButton.new(cell, @drag, @cells), column, line, 1, 1)
		end

		add(@cells)
	end

end

class GameFrame < Frame


	def initialize(map)
		super()
		self.border_width = 10
		@grid = map.solution
		@map  = map

		self.createMainLayout

		@main.show_all
	end


	def createMainLayout()
	
		@header  = createHeaderLayout()
		@content = createContentLayout() 

		@main = Gtk::Box.new(:vertical, 2)
		@main.pack_start(@header)
		@main.pack_start(@content, :expand => true, :fill => true)

		self.add(@main)
	
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
