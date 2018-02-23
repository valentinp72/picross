require_relative '../../../Map'

require_relative '../../Frame'
require_relative 'PicrossFrame'

class GameFrame < Frame


	def initialize(map)
		super()
		self.border_width = 10
		@grid = map.hypotheses.getWorkingHypothesis.grid
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

		testIcon  = File.expand_path(File.dirname(__FILE__) + "/../../../assets/btnReturn.png")
		btnBack   = Gtk::Image.new(:file => testIcon)
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
		image = File.expand_path(File.dirname(__FILE__) + "/../../../assets/pause2.png")
		@reset  = Gtk::Image.new(:file => image)
		image = File.expand_path(File.dirname(__FILE__) + "/../../../assets/pause2.png")
		@pause  = Gtk::Image.new(:file => image)
		image = File.expand_path(File.dirname(__FILE__) + "/../../../assets/pause2.png")
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
