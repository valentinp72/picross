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
			self.setCSSClass
		end

		self.signal_connect('leave_notify_event') do |widget, event|
		end

		self.setCSSClass()
		self.add(@widget)

	end

	def setCSSClass()
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

	def initialize(grid, columnSolution, lineSolution)
		super()
		self.border_width = 20
		@grid = grid
		@lineSolution = lineSolution
		@columnSolution = columnSolution

		createArea()
	end

	def createArea()
		@cells = Gtk::Grid.new
		@drag  = Drag.new(@grid, @cells)

		lineOffset = @lineSolution.map(&:length).max
		columnOffset = @columnSolution.map(&:length).max

		@drag.setOffsets(lineOffset, columnOffset)

		createNumbers(@cells, @columnSolution, lineOffset, columnOffset, false)
		createNumbers(@cells, @lineSolution, lineOffset, columnOffset, true)

		@grid.each_cell_with_index do |cell, line, column|
			@cells.attach(CellButton.new(cell, @drag, @cells), column + columnOffset, line + lineOffset, 1, 1)
		end

		add(@cells)
	end

	def createNumbers(cells,solution, lineOffset, columnOffset, isHorizontal)

		css_provider = Gtk::CssProvider.new
		css_provider.load(data: "
			.number {
				min-width : 20px;
				min-height: 20px;
				border    : 1px solid lightgray;
				color     : black;
			}
		")

		isHorizontal ? offset = lineOffset : offset = columnOffset
		i = 0
		solution.each do |n|
			j = 0
			n = n.reverse.fill(n.size..offset - 1){ nil }
			n.reverse.each do |m|
				label = Gtk::Label.new(m.to_s)
				label.style_context.add_class("number")
				label.style_context.add_provider(
						css_provider,
						Gtk::StyleProvider::PRIORITY_USER
				)
				if isHorizontal then
					cells.attach(label,j,i+lineOffset,1,1)
				else
					cells.attach(label,i+columnOffset,j,1,1)
				end
				j+= 1
			end
			i+= 1
		end
	end
end

class GameFrame < Frame


	def initialize(map)
		super()
		self.border_width = 10
		@grid = map.solution#hypotheses.getWorkingHypothesis.grid
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

		testIcon = File.expand_path(File.dirname(__FILE__) + "/../../assets/btnReturn.png")
		btnBack  = Gtk::Image.new(:file => testIcon)
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

		@picross = PicrossFrame.new(@grid, @map.clmSolution, @map.lneSolution)
		@sideBar = createSideBarLayout()

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar)

		return @content
	end

	def createSideBarLayout()

		@timer = Gtk::Label.new("Timer")
		image = File.expand_path(File.dirname(__FILE__) + "/../../assets/pause2.png")
		@reset  = Gtk::Image.new(:file => image)
		image = File.expand_path(File.dirname(__FILE__) + "/../../assets/pause2.png")
		@pause  = Gtk::Image.new(:file => image)
		image = File.expand_path(File.dirname(__FILE__) + "/../../assets/pause2.png")
		@hypot  = Gtk::Image.new(:file => image)
		@help  = Gtk::Button.new(:label => "help")
		##css_provider = Gtk::CssProvider.new
		##css_provider.load(data: "
		##	image{
		##		background-image: url(image);
		##	}
		#{#}")
		##@help.style_context.add_provider(
		##		css_provider,
		##		Gtk::StyleProvider::PRIORITY_USER
		##)
		@sideBar = Gtk::Box.new(:vertical)
		@sideBar.pack_start(@timer, :expand => true, :fill => true)
		@sideBar.pack_start(@reset, :expand => true, :fill => true)
		@sideBar.pack_start(@pause, :expand => true, :fill => true)
		@sideBar.pack_start(@hypot, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

end
