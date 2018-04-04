require 'yaml'

require_relative 'MapFrame'
require_relative 'HomeFrame'
require_relative '../Frame'
require_relative '../AssetsLoader'
require_relative '../GridCreator'
require_relative '../ButtonCreator'

##
# File          :: ChapterFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the ChapterFrame which list all chapter of an user
class ChapterFrame < Frame

	LOCK_IMAGE = AssetsLoader.loadImage('lock.png', 20)

	STAR_IMAGE = AssetsLoader.loadImage('star.png', 20)

	def initialize(user)
		super()
		@user = user
		self.border_width = 10
		self.add(createArea)
	end

	def createArea
		buttons = []
		buttons << self.createReturnButton
		@user.each_chapter do |chapter|
			buttons << self.createChapterButton(chapter)
		end
		return GridCreator.fromArray(buttons, :vertical => true)
	end

	def createReturnButton
		return ButtonCreator.new(
			:assetName => "arrow-left.png",
			:assetSize => 40,
			:clicked   => :btn_return_clicked,
			:parent    => self
		)
	end

	def createChapterButton(chapter)
		contents = self.chapterButtonContents(chapter)
		content = GridCreator.fromArray(contents, :horizontal => true, :xSizes => [10])
		content.column_spacing = 10
		button  = Gtk::Button.new
		button.add(content)
		button.signal_connect('clicked') do
			self.parent.setFrame(MapFrame.new(@user, chapter))
		end
		return button
	end

	def chapterButtonContents(chapter)
		contents = []

		if chapter.unlocked?(@user) then
			contents << Gtk::Label.new(chapter.title)
		else
			contents << AssetsLoader.cloneImage(LOCK_IMAGE)
			contents << Gtk::Label.new("#{@user.totalStars}/#{chapter.starsRequired}")
			contents << AssetsLoader.cloneImage(STAR_IMAGE)
		end

		return contents
	end

	def btn_return_clicked
		self.parent.setFrame(HomeFrame.new(@user))
	end

end
