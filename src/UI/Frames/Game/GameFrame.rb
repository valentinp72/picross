require_relative '../../../Map'

require_relative '../../AssetsLoader'

require_relative '../MapFrame'
require_relative '../OptionFrame'

require_relative 'PicrossFrame'

require_relative 'HypotheseFrame'

class GameFrame < Frame

	def initialize(user, chapter, map)
		super()
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
			@map.hypotheses = hypotheses
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

		@picross = PicrossFrame.new(@map,@grid)
		@sideBar = createSideBarLayout()

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar)

		return @content
	end

	def createSideBarLayout()

		@timer = Gtk::Label.new(@map.currentStat.time.elapsedTime)

		# Update the timer view every second
		GLib::Timeout.add(1000){
			if @timer == nil then
				# we return false (that stop the timeout) if we have quit the game
				false
			else
				# view update
				@timer.text = @map.currentStat.time.elapsedTime
				true
			end
		}

		@timer.signal_connect('unrealize') do
			# when the timer object is destroy, that means we are quitting the
			# game, so we tell the next timeout to be stopped
			@timer = nil
			# we also pause the timer
			@map.currentStat.time.pause
		end

		@reset  = Gtk::Button.new
		@reset.image = AssetsLoader.loadImage('reset.png',40)
		@reset.relief = Gtk::ReliefStyle::NONE
		@reset.signal_connect('clicked') do
			@map.reset
			@picross.grid = @map.hypotheses.getWorkingHypothesis.grid
			@content.remove(@picross)
			@content.pack_start(@picross, :expand => true, :fill => true)
			@content.reorder_child(@picross,0)

		end

		@labelPause =  Gtk::Label.new("Partie en pause")
		@labelPause.visible = true
		@isPaused = false

		@pause  = Gtk::Button.new
		@pause.image = AssetsLoader.loadImage('pause2.png',40)
		@pause.relief = Gtk::ReliefStyle::NONE
		@pause.signal_connect('clicked') do
			if !@map.currentStat.isFinished then
				if(@isPaused) then
					@isPaused = false
					@map.currentStat.time.unpause

					@pause.image = AssetsLoader.loadImage('pause2.png',40)

					@content.remove(@labelPause)
					@content.pack_start(@picross, :expand => true, :fill => true)
					@content.reorder_child(@picross,0)
				else
					@isPaused = true
					@map.currentStat.time.pause

					@pause.image = AssetsLoader.loadImage('btnPlay.png',40)

					@content.remove(@picross)
					@content.pack_start(@labelPause, :expand => true, :fill => true)
					@content.reorder_child(@labelPause,0)
				end
			end
		end



		@popover = Gtk::Popover.new()
		@label1 =  Gtk::Label.new("Test")
		@label2 =  Gtk::Label.new("Test2")
		@label3 =  Gtk::Label.new("Test3")

		@labelbox = Gtk::Box.new(:horizontal)

		@labelbox.pack_start(@label1, :expand => true, :fill => true)
		@labelbox.pack_start(@label2, :expand => true, :fill => true)
		@labelbox.pack_start(@label3, :expand => true, :fill => true)

		@popover.position = :top
		@popover.add(@labelbox)
		@labelbox.show_all



		@btnHypotheses = Gtk::Button.new()
		@btnHypotheses.image  = AssetsLoader.loadImage('light-bulb.png', 40)
		@btnHypotheses.relief = Gtk::ReliefStyle::NONE
		@btnHypotheses.signal_connect('clicked') do

			puts "show sow"
			@popover.visible = true


			@map.hypotheses.addNewHypothesis
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid
		end

		@help  = Gtk::Button.new()
		@help.image = AssetsLoader.loadImage("help.jpg",40,40)
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
