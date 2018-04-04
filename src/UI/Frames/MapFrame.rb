require 'yaml'
require_relative 'Game/GameFrame'
require_relative 'ChapterFrame'
require_relative '../Frame'
require_relative '../GridCreator'
require_relative '../ButtonCreator'
require_relative '../MapPreview'

##
# File          :: MapFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the ChapterFrame which list all chapter of an user

class MapFrame < Frame

	DIFFICULTY_FULL = AssetsLoader.loadImage("puzzle.png",       10)
	DIFFICULTY_HALF = AssetsLoader.loadImage("puzzle-half.png",  10)
	DIFFICULTY_EMPT = AssetsLoader.loadImage("puzzle-empty.png", 10)

	def initialize(user, chapter)
		super()
		self.border_width = 10
		@user    = user
		@chapter = chapter
		
		self.add(createButtons)
	end

	def createButtons
		buttons = []
		buttons << createReturnBtn
		@chapter.each_map do |map|
			buttons.push(self.createMapButton(map))
		end
		grid = GridCreator.fromArray(buttons, :vertical => true)
		return grid
	end

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

	def createMapButtonContent(map)
		contents = []
		sizes    = [1, 1, 15, 1]

		if map.allStat.nbFinished > 0 then
			contents << AssetsLoader.loadImage("check.png", 10)
		else
			contents << AssetsLoader.loadImage("empty.png", 10)
		end

		contents << MapPreview.image(map, 40, 40)
		contents << Gtk::Label.new(map.name)
		contents << MapFrame.difficultyImages(map.difficulty.to_i)

		return GridCreator.fromArray(contents, :horizontal => true, :xSizes => sizes)
	end

	def createReturnBtn
		return ButtonCreator.new(
			:assetName => "arrow-left.png",
			:assetSize => 40,
			:clicked   => :btn_return_clicked,
			:parent    => self
		)
	end

	def btn_return_clicked
		self.parent.setFrame(ChapterFrame.new(@user))
	end

	##
	# This method return a Box containing images representing the difficulty.
	# * *Arguments* :
	#   - +difficulty+ -> the difficulty, a number between 0 and 10
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
