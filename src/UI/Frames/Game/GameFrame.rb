require_relative '../../../Map'

require_relative '../../AssetsLoader'

require_relative '../MapFrame'
require_relative '../OptionFrame'

require_relative 'PicrossFrame'

class GameFrame < Frame

	def initialize(user, chapter, map)
		super()
		@grid = map.hypotheses.getWorkingHypothesis.grid
		@map  = map
		@user = user
		@chapter = chapter

		self.createMainLayout

		@colorsHyp = user.settings.hypothesesColors

		@main.show_all

	end


	def createMainLayout()

		@header  = createHeaderLayout()
		@content = createContentLayout()

		@main = Gtk::Box.new(:vertical, 2)
		@main.pack_start(@header)
		@main.pack_start(@content, :expand => true, :fill => true)

		self.children.each do |child|
			self.remove(child)
		end
		self.add(@main)

	end

	def createHeaderLayout()

		btnBack   = Gtk::Button.new
		btnBack.image = AssetsLoader.loadImage("arrow-left.png",50)
		btnBack.relief = Gtk::ReliefStyle::NONE
		title     = Gtk::Label.new(@map.name)
		btnOption = Gtk::Button.new()
		btnOption.image = AssetsLoader.loadImage("cog.png",50)
		btnOption.relief = Gtk::ReliefStyle::NONE

		@header = Gtk::Box.new(:horizontal)
		@header.pack_start(btnBack,   :expand => true, :fill => true)
		@header.pack_start(title,     :expand => true, :fill => true)
		@header.pack_start(btnOption, :expand => true, :fill => true)

		btnBack.signal_connect("clicked") do
			self.save
			self.parent.setFrame(MapFrame.new(@user,@chapter))
		end

		# Redirecting user towards option menu
		btnOption.signal_connect("clicked") do
			self.save
			self.parent.setFrame(OptionFrame.new(@user, self))
		end

		return @header
	end

	def draw
		self.createMainLayout
	end

	def save()
		indexChapter = @user.chapters.index(@chapter)
		indexMap     = @user.chapters[indexChapter].levels.index(@map)
		hypotheses   = @user.chapters[indexChapter].levels[indexMap].hypotheses
		@map.hypotheses = hypotheses
		@user.save()
		return self
	end

	def createContentLayout()


		@content = Gtk::Box.new(:horizontal)

		@picross = PicrossFrame.new(@map, @grid, @user)
		# @picross.halign = Gtk::Align::CENTER
		@sideBar = createSideBarLayout()

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar)

		return @content
	end

	def createSideBarLayout()

		@timer = Gtk::Label.new(@map.currentStat.time.elapsedTime)

		# Update the timer view every second
		GLib::Timeout.add(1000){
			checkMap
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
			self.save
		end

		@reset  = Gtk::Button.new()
		@reset.image = AssetsLoader.loadImage('reset.png',40)
		@reset.relief = Gtk::ReliefStyle::NONE
		@reset.signal_connect('clicked') do
			@map.reset
			@map.currentStat.time.unpause
			@picross.grid = @map.hypotheses.getWorkingHypothesis.grid
			@content.remove(@picross)
			@content.pack_start(@picross, :expand => true, :fill => true)
			@content.reorder_child(@picross,0)
			checkMap

			puts @map
		end

		@labelPause =  Gtk::Label.new("Partie en pause")
		@labelPause.visible = true
		@isPaused = false

		@pause  = Gtk::Button.new
		@pause.image = AssetsLoader.loadImage('pause.png',40)
		@pause.relief = Gtk::ReliefStyle::NONE
		@pause.signal_connect('clicked') do
			if checkMap then
				if(@isPaused) then
					@isPaused = false
					@map.currentStat.time.unpause

					@pause.image = AssetsLoader.loadImage('pause.png',40)

					@content.remove(@labelPause)
					@content.pack_start(@picross, :expand => true, :fill => true)
					@content.reorder_child(@picross,0)
				else
					@isPaused = true
					@map.currentStat.time.pause

					@pause.image = AssetsLoader.loadImage('play.png',40)

					@content.remove(@picross)
					@content.pack_start(@labelPause, :expand => true, :fill => true)
					@content.reorder_child(@labelPause,0)
				end
			end
		end


		@btnHypotheses = Gtk::Button.new()

		@popover = Gtk::Popover.new(@btnHypotheses)
		@popover.position = :top

		popoverBox = Gtk::Box.new(:horizontal)

		@btnHypotheses.image  = AssetsLoader.loadImage('lightbulb.png', 40)
		@btnHypotheses.relief = Gtk::ReliefStyle::NONE
		@btnHypotheses.signal_connect('clicked') do
			if checkMap then
				updatePopover(popoverBox)
			end
		end

		#puts @btnHypotheses.methods
		#@btnHypotheses.popover = @popover

		@help  = Gtk::Button.new()
		@help.image = AssetsLoader.loadImage("help.png",40)
		@help.relief = Gtk::ReliefStyle::NONE
		@help.signal_connect('clicked') do
			checkMap
		end

		@sideBar = Gtk::Box.new(:vertical)
		@sideBar.pack_start(@timer, :expand => true, :fill => true)
		@sideBar.pack_start(@reset, :expand => true, :fill => true)
		@sideBar.pack_start(@pause, :expand => true, :fill => true)
		@sideBar.pack_start(@btnHypotheses, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

	def updatePopover(popoverBox)

		@colorsHyp = @user.settings.hypothesesColors
		@popover.remove(popoverBox)

		popoverBox.children.each do |child|
			popoverBox.remove(child)
		end

		@map.hypotheses.each do |hypo|

			boxHypo = Gtk::Box.new(:vertical)

			css_provider = Gtk::CssProvider.new
			css_provider.load(data: <<-CSS)
				button {
					background-image: image(#{@colorsHyp[hypo.id]});
				}
			CSS

			buttonAccept = Gtk::Button.new()
			buttonAccept.image = AssetsLoader.loadImage('check.png',40)
			buttonAccept.style_context.add_provider(
					css_provider,
					Gtk::StyleProvider::PRIORITY_USER
			)

			buttonAccept.signal_connect('clicked') do
				@map.hypotheses.validate(hypo.id)
				@grid = @map.hypotheses.getWorkingHypothesis.grid
				@picross.grid = @grid
				updatePopover(popoverBox)
			end

			buttonReject = Gtk::Button.new()
			buttonReject.style_context.add_provider(
					css_provider,
					Gtk::StyleProvider::PRIORITY_USER
			)
			buttonReject.image = AssetsLoader.loadImage('close.png',40)
			buttonReject.signal_connect('clicked') do
				@map.hypotheses.reject(hypo.id)
				@grid = @map.hypotheses.getWorkingHypothesis.grid
				@picross.grid = @grid
				updatePopover(popoverBox)
			end

			boxHypo.pack_start(buttonAccept)
			boxHypo.pack_start(buttonReject)

			popoverBox.pack_start(boxHypo)
		end

		buttonNewHypo = Gtk::Button.new()
		buttonNewHypo.image = AssetsLoader.loadImage('plus.png',40)
		buttonNewHypo.signal_connect('clicked') do
			@map.hypotheses.addNewHypothesis
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid
			updatePopover(popoverBox)
		end

		popoverBox.pack_start(buttonNewHypo)

		popoverBox.show_all
		@popover.add(popoverBox)
		@popover.visible = true
	end

	def checkMap
		if @map.currentStat.isFinished then
			@btnHypotheses.sensitive = false
			@pause.sensitive = false
			@help.sensitive = false
			return false
		else
			@btnHypotheses.sensitive = true
			@pause.sensitive = true
			@help.sensitive = true
			return true
		end
	end
end
