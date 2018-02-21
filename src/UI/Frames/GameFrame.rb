require_relative '../Frame'

require_relative '../../Map'
require_relative '../../Cell'
require_relative '../../Drag'

class CellButton < Gtk::ToggleButton

	attr_reader :cell

	def initialize(cell)
		super()
		#self.set_focus_on_click(false)
#self.set_imddage()

		css_provider = Gtk::CssProvider.new
		css_provider.load(data: "
			button {
				background-image: none;
				background-color: white;
				border-radius:    0px;
				box-shadow:       none;
				border-width:     1px;
				border-color:     black;
			}
			button:hover {
			}
			button:active {
				background-color: red;
			}
			button .toggle {
				background-color: blue;
			}
		")

		self.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

		@cell = cell
	end

end

class PicrossFrame < Frame
	
	BUTTON_LEFT_CLICK  = 1
	BUTTON_RIGHT_CLICK = 3 

	def initialize(grid)
		super()
		self.border_width = 20
		@grid = grid

#	puts self.methods
#		print self.realize
#:		print self.allocated_size

#		self.set_size_request(100, 100)
		createArea()
	end

	def createArea()
		@cells = Gtk::Grid.new

		@grid.each_cell_with_index do |cell, line, column|
			@cells.attach(CellButton.new(cell), line, column, 1, 1)
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
