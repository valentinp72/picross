require 'yaml'

require_relative 'Game/GameFrame'
require_relative 'ChapterFrame'

require_relative '../Frame'
require_relative '../GridCreator'
require_relative '../ButtonCreator'
require_relative '../MapPreview'

##
# File          :: MapFrame.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 04/04/2018
# Version       :: 0.1
#
# This class represents the ChapterFrame which list all chapter of an user

class MapFrame < Frame

	# The image representing a difficulty point
	DIFFICULTY_FULL = AssetsLoader.loadImage("puzzle.png",       10)

	# The image representing a half difficulty point
	DIFFICULTY_HALF = AssetsLoader.loadImage("puzzle-half.png",  10)

	# The image representing no difficulty point
	DIFFICULTY_EMPT = AssetsLoader.loadImage("puzzle-empty.png", 10)

	# The image to show when a map is done
	MAP_DONE     = AssetsLoader.loadImage("check.png", 10)

	# The image to show when a map is not done
	MAP_NOT_DONE = AssetsLoader.loadImage("empty.png", 10)

	##
	# Create a new Frame that show all the Map of a Chapter.
	# * *Arguments* :
	#   - +user+ -> the user the frame is showing the maps of
	#   - +chapter+ -> the chapter to show
	def initialize(user, chapter)
		super()
		self.border_width = 10
		@user    = user
		@chapter = chapter
		
		self.add(createButtons)
	end

	##
	# Create all the buttons in the frame
	# * *Returns* :
	#   - a Gtk::Grid with all the buttons of the frame
	def createButtons
		buttons = []
		buttons << createReturnBtn
		@chapter.each_map do |map|
			buttons.push(self.createMapButton(map))
		end
		return GridCreator.fromArray(buttons, :vertical => true)
	end

	##
	# Create a button for a Map
	# * *Arguments* :
	#   - +map+ -> the map this button will be showing
	# * *Returns* :
	#   - a Gtk::Button for this map
	def createMapButton(map)
		content = self.createMapButtonContent(map)
		content.column_spacing = 10
		content.row_spacing    = 0
		button  = Gtk::Button.new
		button.add(content)
		button.signal_connect('clicked') do
			self.parent.setFrame(GameFrame.new(@user, @chapter, map))
		end
		return button
	end

	##
	# Create the content (a Gtk::Grid) for a button of a Map
	# * *Arguments* :
	#   - +map+ -> the map this content will be showing
	# * *Returns* :
	#   - a Gtk::Grid with all  the content inside the button
	def createMapButtonContent(map)
		contents = []
		sizes    = [1, 1, 15, 1]

		if map.allStat.nbFinished > 0 then
			contents << AssetsLoader.cloneImage(MAP_DONE)
		else
			contents << AssetsLoader.cloneImage(MAP_NOT_DONE)
		end

		contents << MapPreview.image(map, 40, 40)
		contents << Gtk::Label.new(map.name)
		contents << MapFrame.difficultyImages(map.difficulty.to_i)

		return GridCreator.fromArray(contents, :horizontal => true, :xSizes => sizes)
	end

	##
	# Create the return button for this map
	# * *Returns* :
	#   - a Gtk::Button
	def createReturnBtn
		return ButtonCreator.new(
			:assetName => "arrow-left.png",
			:assetSize => 40,
			:clicked   => :btn_return_clicked,
			:parent    => self
		)
	end

	##
	# The action to be done when clicking on the return button
	# * *Returns* :
	#   - the frame itself
	def btn_return_clicked
		self.parent.setFrame(ChapterFrame.new(@user))
		return self
	end

	##
	# This method return a Box containing images representing the difficulty.
	# * *Arguments* :
	#   - +difficulty+ -> the difficulty, a number between 0 and 10
	# * *Returns* :
	#   - a Gtk::Grid with all the images showing the difficulty
	def MapFrame.difficultyImages(difficulty)
		images = []
		emptyNumber = 10 - difficulty

		(difficulty / 2).times do
			images << AssetsLoader.cloneImage(DIFFICULTY_FULL)
		end
		if !difficulty.even? then
			images << AssetsLoader.cloneImage(DIFFICULTY_HALF)
		end
		(emptyNumber / 2).times do
			images << AssetsLoader.cloneImage(DIFFICULTY_EMPT)
		end

		return GridCreator.fromArray(images, :horizontal => true) 
	end

end
