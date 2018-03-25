require_relative '../../../Map'
require_relative '../../AssetsLoader'
require_relative '../../ButtonCreator'
require_relative '../MapFrame'
require_relative '../OptionFrame'
require_relative 'PicrossFrame'

##
# File          :: CellButton.rb
# Author        :: PELLOIN Valentin, BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/23/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class represents the frame the game is displayed on. On this frame, there is :
#   - the picross (a PicrossFrame)
#   - the header bar (back button, picross name, configuration button)
#   - the side bar buttons (timer, pause, hypotheses, helps)

class GameFrame < Frame

	# The PicrossFrame
	attr_reader :picross

	##
	# Create a new frame that shows the game
	# * *Arguments* :
	#   - +user+ -> the user that is playing on this frame
	#   - +chapter+ -> the chapter the frame is displaying
	#   - +map+ -> the map to show on this frame
	def initialize(user, chapter, map)
		super()
		@grid = map.hypotheses.getWorkingHypothesis.grid
		@map  = map
		@user = user
		@chapter = chapter

		self.createMainLayout

		@colorsHyp = user.settings.hypothesesColors
		@isPaused  = false
		@main.show_all
	end

	##
	# Create the main layout of this frame
	# * *Returns* :
	#   - the frame itself
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
		return self
	end

	##
	# Creates and returns the layout of the header of this frame.
	# This contains the back button, the title of the map, and the
	# option button.
	# * *Returns* :
	#   - the Gtk::Box containing the header
	def createHeaderLayout()
		title = Gtk::Label.new(@map.name)

		@btnBack = createBackButton
		@btnOption = createOptionButton

		@header = Gtk::Box.new(:horizontal)
		@header.pack_start(@btnBack,   :expand => true, :fill => true)
		@header.pack_start(title,     :expand => true, :fill => true)
		@header.pack_start(@btnOption, :expand => true, :fill => true)

		return @header
	end

	##
	# Creates and returns the layout of the content of this frame.
	# This contains the PicrossFrame and the sidebar.
	# * *Returns* :
	#   - the Gtk::Box containing the content
	def createContentLayout()
		@content = Gtk::Box.new(:horizontal)
		@sideBar = createSideBarLayout()
		@picross = PicrossFrame.new(@map, @grid, @user, self)
		self.checkMap

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar)

		return @content
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
			self.save
		end

		@reset = createResetButton()
		@pause = createPauseButton()
		@help  = createHelpButton()

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
		if(popoverBox.parent == @popover) then
			@popover.remove(popoverBox)
		end

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

	def checkMap()
		@picross.setDoneValues if @picross != nil
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

	##
	# Ask to draw the the game frame.
	# * *Returns* :
	#   - the frame itself
	def draw
		self.createMainLayout

		if(@isPaused) then
			drawOnPause
		else
			drawOnUnpause
		end
		return self
	end

	##
	# Ask the frame to save everything
	# * *Returns* :
	#   - the frame itself
	def save()
		indexChapter = @user.chapters.index(@chapter)
		indexMap     = @user.chapters[indexChapter].levels.index(@map)
		hypotheses   = @user.chapters[indexChapter].levels[indexMap].hypotheses
		@map.hypotheses = hypotheses
		@user.save()
		return self
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
		ButtonCreator.new(:assetName => 'pause.png', :assetSize => 40) 
	end

	def createBackButton()
		ButtonCreator.new(:assetName => 'arrow-left.png', :assetSize => 40) 
	end

	def createOptionButton()
		ButtonCreator.new(:assetName => 'cog.png', :assetSize => 40) 
	end

	def createHelpButton()
		ButtonCreator.new(:assetName => 'help.png', :assetSize => 40) 
	end

	def btn_reset_clicked
		@map.reset
		@map.currentStat.time.unpause
		@picross.grid = @map.hypotheses.getWorkingHypothesis.grid
		@content.remove(@picross)
		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.reorder_child(@picross,0)
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

	def btn_back_clicked
		self.save
		self.parent.setFrame(MapFrame.new(@user,@chapter))
	end

	def btn_option_clicked
		self.save
		self.parent.setFrame(OptionFrame.new(@user, self))
	end

	def btn_help_clicked
		self.checkMap
	end

end
