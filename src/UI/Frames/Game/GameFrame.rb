require_relative '../../../Map'

require_relative '../../AssetsLoader'

require_relative '../MapFrame'
require_relative '../OptionFrame'

require_relative 'PicrossFrame'

class GameFrame < Frame

	def initialize(user, chapter, map)
		super()
		self.border_width = 10
		@grid = map.hypotheses.getWorkingHypothesis.grid
		@map  = map
		@user = user
		@chapter = chapter

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

		btnBack   = Gtk::Button.new
		btnBack.image = AssetsLoader.loadImage("btnReturn.png",50)
		btnBack.relief = Gtk::ReliefStyle::NONE
		title     = Gtk::Label.new(@map.name)
		btnOption = Gtk::Button.new()
		btnOption.image = AssetsLoader.loadImage("btnOption.png",50)
		btnOption.relief = Gtk::ReliefStyle::NONE

		@header = Gtk::Box.new(:horizontal)
		@header.pack_start(btnBack,   :expand => true, :fill => true)
		@header.pack_start(title,     :expand => true, :fill => true)
		@header.pack_start(btnOption, :expand => true, :fill => true)

		btnBack.signal_connect("clicked") do
			indexChapter = @user.chapters.index(@chapter)
			indexMap = @user.chapters[indexChapter].levels.index(@map)
			hypotheses = @user.chapters[indexChapter].levels[indexMap].hypotheses
			hypotheses = @map.hypotheses
			@user.save()
			self.parent.setFrame(MapFrame.new(@user,@chapter))
		end

		# Redirecting user towards option menu
		btnOption.signal_connect("clicked") do
			self.parent.setFrame(GameOptionFrame.new(@user,@chapter,@map))
		end

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

		@reset  = Gtk::Button.new
		@reset.image = AssetsLoader.loadImage('reset.png',40)
		@reset.relief = Gtk::ReliefStyle::NONE

		@pause  = Gtk::Button	.new
		@pause.image = AssetsLoader.loadImage('pause2.png',40)
		@pause.relief = Gtk::ReliefStyle::NONE
		@pause.signal_connect('clicked') do

		end

		@btnHypotheses = Gtk::Button.new()
		@btnHypotheses.image  = AssetsLoader.loadImage('light-bulb.png', 40)
		@btnHypotheses.relief = Gtk::ReliefStyle::NONE
		@btnHypotheses.signal_connect('clicked') do
			@map.hypotheses.addNewHypothesis
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid
		end

		@help  = Gtk::Button.new()
		@reset.image = AssetsLoader.loadImage("help..jpg",40,40)
		@help.relief = Gtk::ReliefStyle::NONE
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
		@sideBar.pack_start(@btnHypotheses, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

end
