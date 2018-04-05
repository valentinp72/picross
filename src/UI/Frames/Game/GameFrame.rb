require_relative '../../../Map'
require_relative '../../AssetsLoader'
require_relative '../../ButtonCreator'
require_relative '../MapFrame'
require_relative '../OptionFrame'
require_relative 'PicrossFrame'
require_relative 'SideBarGameFrame'

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

	# The main layout of this frame
	attr_reader :content

	##
	# Create a new frame that shows the game
	# * *Arguments* :
	#   - +user+ -> the user that is playing on this frame
	#   - +chapter+ -> the chapter the frame is displaying
	#   - +map+ -> the map to show on this frame
	def initialize(user, chapter, map)
		super()
		@grid = map.grid
		@map  = map
		@user = user
		@chapter = chapter

		self.createMainLayout

		self.signal_connect('size-allocate') do |widget, event|
			self.parent.addKeyBinding(@picross.keyboard.method(:on_key_press_event))
		end

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
		@sideBar = SideBarGameFrame.new(self, @user, @picross, @map, @grid)
		@picross = PicrossFrame.new(@map, @grid, @user, self)
		@sideBar.picross = @picross
		@sideBar.checkMap

		@content.pack_start(@picross, :expand => true, :fill => true)
		@content.pack_start(@sideBar.sideBar)

		return @content
	end

	##
	# Ask to draw the the game frame.
	# * *Returns* :
	#   - the frame itself
	def draw
		puts "on draw"
		self.createMainLayout

		if(@isPaused) then
			@sideBar.drawOnPause
		else
			@sideBar.drawOnUnpause
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

	def createBackButton()
		ButtonCreator.new(
				:assetName => 'arrow-left.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_back_clicked
		)
	end

	def createOptionButton()
		ButtonCreator.new(
				:assetName => 'cog.png',
				:assetSize => 40,
				:parent    => self,
				:clicked   => :btn_option_clicked
		)
	end

	def btn_back_clicked
		self.save
		self.parent.setFrame(MapFrame.new(@user,@chapter))
	end

	def btn_option_clicked
		self.save
		self.parent.setFrame(OptionFrame.new(@user, self))
	end

	def checkMap
		@sideBar.checkMap
	end

end
