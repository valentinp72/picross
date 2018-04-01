require_relative '../../../Map'
require_relative '../../AssetsLoader'
require_relative '../../ButtonCreator'
require_relative '../MapFrame'
require_relative '../OptionFrame'
require_relative 'PicrossFrame'

class SideBarGameFrame

	attr_reader :sideBar

	def initialize(frame, user, picross, map, grid)
		@frame = frame
		@user = user
		@picross = picross
		@map = map
		@grid = grid

		@sideBar = createSideBarLayout
		@sideBar.show_all
		return @sideBar
	end

	##
	# Creates and returns the layout of the sidebar of this frame.
	# This contains the timer and the buttons.
	# * *Returns* :
	#   - the Gtk::Box containing the sidebar
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
			@frame.save
		end

		@reset = createResetButton()
		@pause = createPauseButton()
		@help  = createHelpButton()

		@btnHypotheses = Gtk::Button.new()

		@popover = Gtk::Popover.new(@btnHypotheses)
		@popover.position = :top

		@popoverBox = Gtk::Box.new(:horizontal)

		@btnHypotheses.image  = AssetsLoader.loadImage('lightbulb.png', 40)
		@btnHypotheses.relief = Gtk::ReliefStyle::NONE
		@btnHypotheses.signal_connect('clicked') do
			if self.checkMap then
				updatePopover(@popoverBox)
			end
		end

		@sideBar = Gtk::Box.new(:vertical)
		@sideBar.pack_start(@timer, :expand => true, :fill => true)
		@sideBar.pack_start(@reset, :expand => true, :fill => true)
		@sideBar.pack_start(@pause, :expand => true, :fill => true)
		@sideBar.pack_start(@btnHypotheses, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

	def createResetButton()
		ButtonCreator.new(
				:assetName => 'reset.png',
				:assetSize => 40,
				:clicked => :btn_reset_clicked,
				:parent => self
		)
	end

	def createPauseButton()
		@labelPause =  Gtk::Label.new(@user.lang['game']['paused'])
		@labelPause.visible = true
		ButtonCreator.new(
				:assetName => 'pause.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_pause_clicked
		)
	end

	def createHelpButton()
		ButtonCreator.new(
				:assetName => 'help.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_help_clicked
		)
	end

	def btn_reset_clicked
		@map.reset
		@map.currentStat.time.unpause
		@picross.grid = @map.hypotheses.workingHypothesis.grid
		@picross.redraw
		self.checkMap
	end

	def btn_pause_clicked
		if self.checkMap then
			if @isPaused then
				self.drawOnUnpause
			else
				self.drawOnPause
			end
			@isPaused = !@isPaused
		end
	end

	def btn_help_clicked
		self.checkMap
	end

	def drawOnUnpause()
		@map.currentStat.time.unpause

		@btnHypotheses.sensitive = true
		@reset.sensitive = true
		@help.sensitive = true

		@pause.image = AssetsLoader.loadImage('pause.png',40)
		@picross.show_all

		@content.remove(@labelPause)
		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.reorder_child(@picross,0)
	end

	def drawOnPause()
		@map.currentStat.time.pause

		@btnHypotheses.sensitive = false
		@reset.sensitive = false
		@help.sensitive = false

		@pause.image = AssetsLoader.loadImage('play.png',40)

		@content.remove(@picross)
		@content.pack_start(@labelPause, :expand => true, :fill => true)
		@content.reorder_child(@labelPause,0)
	end

	def createPopoverButton(buttonAccept, buttonReject, hypo)
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: <<-CSS)
			button {
				background-image: image(#{@colorsHyp[hypo.id]});
			}
		CSS

		buttonAccept.image = AssetsLoader.loadImage('check.png', 40)
		buttonAccept.style_context.add_provider(
				css_provider,
				Gtk::StyleProvider::PRIORITY_USER
		)

		buttonAccept.signal_connect('clicked') do
			@map.hypotheses.validate(hypo.id)
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid
			updatePopover(@popoverBox)
		end

		buttonReject.style_context.add_provider(
				css_provider,
				Gtk::StyleProvider::PRIORITY_USER
		)
		buttonReject.image = AssetsLoader.loadImage('close.png',40)
		buttonReject.signal_connect('clicked') do
			@map.hypotheses.reject(hypo.id)
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid
			updatePopover(@popoverBox)
		end
	end

	def updatePopover(popoverBox)

		@colorsHyp = @user.settings.hypothesesColors
		if popoverBox.parent == @popover then
			@popover.remove(popoverBox)
		end

		popoverBox.children.each do |child|
			popoverBox.remove(child)
		end

		@map.hypotheses.each do |hypo|

			boxHypo = Gtk::Box.new(:vertical)

			buttonAccept = Gtk::Button.new()
			buttonReject = Gtk::Button.new()

			createPopoverButton(buttonAccept, buttonReject, hypo)

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

	def checkMap()
		@picross.setDoneValues if @picross != nil
		if @map.currentStat.isFinished then
			@grid = @map.hypotheses.getWorkingHypothesis.grid
			@picross.grid = @grid if @picross != nil
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