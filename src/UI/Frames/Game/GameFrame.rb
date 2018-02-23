require_relative '../../../Map'

require_relative '../MapFrame'

require_relative '../OptionFrame'

require_relative 'PicrossFrame'

class GameFrame < Frame

  BUTTON_LEFT_CLICK = 1

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

		testIcon  = File.expand_path(File.dirname(__FILE__) + " /../../../assets/btnReturn.png")
		btnBack   = Gtk::EventBox.new
		imgBack   = Gtk::Image.new(:file => testIcon)
		title     = Gtk::Label.new(@map.name)
		btnOption = Gtk::Button.new(:label => "Options")

		@header = Gtk::Box.new(:horizontal)
		@header.pack_start(btnBack,   :expand => true, :fill => true)
		@header.pack_start(title,     :expand => true, :fill => true)
		@header.pack_start(btnOption, :expand => true, :fill => true)

		btnBack.add(imgBack)
		btnBack.events |= (Gdk::EventMask::BUTTON_PRESS_MASK)
		btnBack.signal_connect("button_press_event") do |widget, event|
			# force to not grab focus on current button
			Gdk.pointer_ungrab(Gdk::CURRENT_TIME)

			if event.button == BUTTON_LEFT_CLICK then
				indexChapter = @user.chapters.index(@chapter)
				indexMap = @user.chapters[indexChapter].levels.index(@map)
				hypotheses = @user.chapters[indexChapter].levels[indexMap].hypotheses
				hypotheses = @map.hypotheses
				@user.save()
				self.parent.setFrame(MapFrame.new(@user,@chapter))
			end
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
