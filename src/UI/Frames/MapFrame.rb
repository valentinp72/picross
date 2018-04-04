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
		content.column_spacing = 0
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

		contents << AssetsLoader.loadImage("check.png", 10) if map.allStat.nbFinished > 0
		contents << MapPreview.image(map, 40, 40)
		contents << Gtk::Label.new(map.name)
		contents << MapFrame.difficultyImages(map.difficulty)

		return GridCreator.fromArray(contents, :horizontal => true)
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
	# This method return a Box containing stars.
	# The numbers of stars visible is proporional to the difficulty of the level
	def MapFrame.difficultyImages(score)
		score = score.to_i
		starBox = Gtk::Box.new(:horizontal)
		emptyStarNumber = 10 - score
		(score / 2).times do
			starBox.pack_start(AssetsLoader.loadImage("puzzle.png", 10), :expand => true, :fill => true, :padding => 0)
		end
		if !score.even? then
			starBox.pack_start(AssetsLoader.loadImage("puzzle-half.png", 10), :expand => true, :fill => true, :padding => 0)
		end

		(emptyStarNumber / 2).times do
			starBox.pack_start(AssetsLoader.loadImage("puzzle-empty.png", 10), :expand => true, :fill => true, :padding => 0)
		end
		return starBox
	end


end
