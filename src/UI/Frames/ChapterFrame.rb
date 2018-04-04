require 'yaml'

require_relative 'MapFrame'
require_relative 'HomeFrame'

require_relative '../Frame'
require_relative '../AssetsLoader'
require_relative '../GridCreator'
require_relative '../ButtonCreator'

##
# File          :: ChapterFrame.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 04/04/2018
# Version       :: 0.1
#
# This class represents the ChapterFrame which list all chapter of an user

class ChapterFrame < Frame

	# The image to show when a chapter is locked
	LOCK_IMAGE = AssetsLoader.loadImage('lock.png', 20)

	# The image to explain a star
	STAR_IMAGE = AssetsLoader.loadImage('star.png', 20)

	##
	# Create a new ChapterFrame, displaying all the chapters of a User.
	# * *Arguments* :
	#   - +user+ -> the user to show it's chapters
	def initialize(user)
		super()
		@user = user
		self.border_width = 10
		self.add(createArea)
	end

	##
	# Create the main area for this frame (a Gtk::Grid).
	# * *Returns* :
	#   - a Gtk::Grid with everything inside
	def createArea
		buttons = []
		buttons << self.createReturnButton
		@user.each_chapter do |chapter|
			buttons << self.createChapterButton(chapter)
		end
		return GridCreator.fromArray(buttons, :vertical => true)
	end

	##
	# Create the return button
	# * *Returns* :
	#   - the return button to the main page
	def createReturnButton
		return ButtonCreator.new(
			:assetName => "arrow-left.png",
			:assetSize => 40,
			:clicked   => :btn_return_clicked,
			:parent    => self
		)
	end

	##
	# Create a button for a chapter
	# * *Arguments* :
	#   - +chapter+ -> the chapter to show the button about
	# * *Returns* :
	#   - a clickable Gtk::Button for the given chapter
	def createChapterButton(chapter)
		contents = self.chapterButtonContents(chapter)
		content = GridCreator.fromArray(contents, :horizontal => true, :xSizes => [10])
		content.column_spacing = 10
		button  = Gtk::Button.new
		button.add(content)
		if chapter.unlocked?(@user) then
			button.signal_connect('clicked') do
				self.parent.setFrame(MapFrame.new(@user, chapter))
			end
		end
		return button
	end

	##
	# Create and return an Array with every Gtk::Widget that sould 
	# be put inside the button of a chapter.
	# * *Arguments* :
	#   - +chapter+ -> the chapter to show the content about
	# * *Returns* :
	#   - an array with plenty of Gtk::Widget 
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

	##
	# The action to do when the return button is clicked
	# * *Returns* :
	#   - the frame itself
	def btn_return_clicked
		self.parent.setFrame(HomeFrame.new(@user))
		return self
	end

end
