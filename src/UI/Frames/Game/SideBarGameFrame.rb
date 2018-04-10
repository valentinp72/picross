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

require_relative 'Popovers/PopoverHypotheses'
require_relative 'Popovers/PopoverHelps'

class SideBarGameFrame < Frame

	attr_accessor :picross

	attr_reader :map
	attr_reader :user

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
		@help       = createHelpButton()

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
		@popover = PopoverHypotheses.new(@hypotheses, self)
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
		help = ButtonCreator.new(
				:assetName => 'help.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_help_clicked
		)
		@helpers = PopoverHelps.new(help, self)
		return help
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
		@helpers.update
		@helpers.show
	end

	def btn_hypotheses_clicked
		if self.checkMap then
			@popover.update
			@popover.show
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

	def updateGrid()
		@grid = @map.grid
		@picross.grid = @grid
	end

	def checkMap()
		@picross.setDoneValues if @picross != nil
		if @map.currentStat.isFinished  && !@alreadyFinished then
			@hypotheses.sensitive = false
			@pause.sensitive      = false
			@help.sensitive       = false

			totalFinished = 0
			@map.allStat.each do |stat|
				totalFinished += 1 if stat.isFinished == true
			end

			if totalFinished == 1 && !@map.givenHelp then
				@map.givenHelp = true
				@user.addHelp(2)
			end

			self.terminate
			return false
		elsif !@map.currentStat.isFinished then
			@hypotheses.sensitive = true
			@pause.sensitive      = true
			@help.sensitive       = true
			return true
		end
	end

	def terminate
		@grid         = @map.grid
		@picross.grid = @grid if @picross != nil

		@alreadyFinished = true

		message = @user.lang["game"]["finish"]
		dialog = Gtk::MessageDialog.new(
			:parent       => @frame.parent,
			:flags        => :destroy_with_parent,
			:type         => :info,
			:buttons_type => :close,
			:message      => message
		)
		dialog.secondary_text = @user.lang["game"]["finish2"] + @map.currentStat.numberOfStars.to_s + @user.lang["game"]["finish3"] + "\n" + @user.lang["stats"]["global"]["time"] + " : " + Timer.toTime(@map.currentStat.time.elapsedSeconds + @map.currentStat.penalty.seconds)
		dialog.run
		dialog.destroy
	end

end
