require_relative '../../../Map'
require_relative '../../../Timer'
require_relative '../../../HelpMadeError'
require_relative '../../AssetsLoader'
require_relative '../../ButtonCreator'
require_relative '../../GridCreator'
require_relative '../MapFrame'
require_relative '../OptionFrame'
require_relative 'PicrossFrame'
require_relative 'TimerFrame'

class SideBarGameFrame < Frame

	attr_accessor :picross

	attr_reader :sideBar

	def initialize(frame, user, picross, map, grid)
		super()
		@frame   = frame
		@user    = user
		@picross = picross
		@map     = map
		@grid    = grid

		@alreadyFinished = false

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
		@timer      = createTimer()
		@reset      = createResetButton()
		@pause      = createPauseButton()
		@hypotheses = createHypothesesButton()
		@help        = createHelpButton()

		@sideBar = Gtk::Box.new(:vertical)
		@sideBar.pack_start(@timer, :expand => true, :fill => true)
		@sideBar.pack_start(@reset, :expand => true, :fill => true)
		@sideBar.pack_start(@pause, :expand => true, :fill => true)
		@sideBar.pack_start(@hypotheses, :expand => true, :fill => true)
		@sideBar.pack_start(@help,  :expand => true, :fill => true)

		return @sideBar
	end

	def createTimer
		@timer = TimerFrame.new(@map)

		# Update the timer view every second
		GLib::Timeout.add(1000){
			if @timer == nil then
				# we return false (that stop the timeout) if we have quit the game
				false
			else
				@timer.refresh
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
		return @timer
	end

	def createHypothesesButton()
		@hypotheses = ButtonCreator.new(
				:assetName => 'lightbulb.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_hypotheses_clicked
		)
		@popover = Gtk::Popover.new(@hypotheses)
		@popover.position = :top
		@popoverBox = Gtk::Box.new(:horizontal)
		return @hypotheses
	end

	def createResetButton()
		ButtonCreator.new(
				:assetName => 'reset.png',
				:assetSize => 40,
				:clicked   => :btn_reset_clicked,
				:parent    => self
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
		@alreadyFinished = false
		@map.reset
		@map.currentStat.time.unpause
		@picross.grid = @map.grid
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
		#self.checkMap
		help = HelpMadeError.new(@map, @user)
		help.apply
		@picross.grid = @map.grid
		@picross.redraw
	end

	def btn_hypotheses_clicked
		if self.checkMap then
			updatePopover(@popoverBox)
		end
	end

	def disablePause(unpaused, imageName, toRemove, toReplace)
		@hypotheses.sensitive = unpaused
		@reset.sensitive      = unpaused
		@help.sensitive       = unpaused
		@pause.image          = AssetsLoader.loadImage(imageName, 40)

		@frame.content.remove(toRemove)
		@frame.content.pack_start(toReplace, :expand => true, :fill => true)
		@frame.content.reorder_child(toReplace, 0)
	end

	def drawOnUnpause()
		@map.currentStat.time.unpause
		self.disablePause(true, 'pause.png', @labelPause, @picross)
	end

	def drawOnPause()
		@map.currentStat.time.pause
		self.disablePause(false, 'play.png', @picross, @labelPause)
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
			@grid = @map.grid
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
			@grid = @map.grid
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
			@grid = @map.grid
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
		if @map.currentStat.isFinished  && !@alreadyFinished then
			@grid = @map.grid
			@picross.grid = @grid if @picross != nil
			@hypotheses.sensitive = false
			@pause.sensitive = false
			@help.sensitive = false

			@alreadyFinished = true

			message = @user.lang["game"]["finish"]
			@dialog = Gtk::MessageDialog.new(:parent=> @frame.parent, :flags=> :destroy_with_parent,:type => :info,:buttons_type => :close,:message=> message)
			@dialog.secondary_text = @user.lang["game"]["finish2"] + @map.currentStat.numberOfStars.to_s + @user.lang["game"]["finish3"] + "\n" +
				@user.lang["stats"]["global"]["time"] + " : " + Timer.toTime(@map.currentStat.time.elapsedSeconds + @map.currentStat.penalty.seconds)

			@dialog.signal_connect "response" do |dialog, _response_id|
				dialog.destroy
			end
			@dialog.show_all

			return false
		else
			@hypotheses.sensitive = true 
			@pause.sensitive      = true 
			@help.sensitive       = true 
			return true
		end
	end

end
