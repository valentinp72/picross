require 'yaml'
require_relative 'Game/GameFrame'
require_relative 'ChapterFrame'
require_relative '../Frame'

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
		self.border_width = 100

		# Create vertical box containing all chapters buttons
		@vbox = Gtk::Box.new(:vertical, chapter.levels.length)

		# Create a return button
		@returnBtn = Gtk::Button.new()
		@returnBtn.image = AssetsLoader.loadImage("arrow-left.png", 40)
		@returnBtn.relief = Gtk::ReliefStyle::NONE
		@vbox.pack_start(@returnBtn, :expand => true, :fill => true, :padding =>2)

		# List of bouttons
		@buttonsList = Array.new(chapter.levels.length + 1)

		0.upto(chapter.levels.length - 1)  do |x|
			buttonBox = Gtk::Box.new(:horizontal)
			#if(chapter.levels[x].allStat.nbFinished > 0) then
				#buttonBox.pack_start(AssetsLoader.loadImage("check.png", 10), :expand => false, :fill => false, :padding =>2)

				grid = chapter.levels[x].hypotheses.getWorkingHypothesis().grid
				img = drawPreview(grid)

				buttonBox.pack_start(img, :expand => false, :fill => false, :padding =>2)
			#end
			buttonBox.pack_start(Gtk::Label.new(chapter.levels[x].name), :expand => true, :fill => false, :padding =>2)
			buttonBox.pack_start(calculateStar(chapter.levels[x].difficulty), :expand => false, :fill => true, :padding =>2)

			@buttonsList[x] = Gtk::Button.new()
			@buttonsList[x].add(buttonBox)

			@vbox.pack_start(@buttonsList[x], :expand => true, :fill => true, :padding =>2)

			@buttonsList[x].signal_connect("clicked") do
				self.parent.setFrame(GameFrame.new(user,chapter,chapter.levels[x]))
			end
		end

		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(ChapterFrame.new(user))
		end

		# Add vbox to frame
		add(@vbox)
	end

	##
	# This method return a Box containing stars.
	# The numbers of stars visible is proporional to the difficulty of the level
	def calculateStar(score)
		score = score.to_i
		starBox = Gtk::Box.new(:horizontal)
		emptyStarNumber = 10 - score
		(score / 2).times do
			starBox.pack_start(AssetsLoader.loadImage("star.png", 10), :expand => true, :fill => true, :padding => 0)
		end
		if !score.even? then
			starBox.pack_start(AssetsLoader.loadImage("star-half.png", 10), :expand => true, :fill => true, :padding => 0)
		end

		(emptyStarNumber / 2).times do
			starBox.pack_start(AssetsLoader.loadImage("star-empty.png", 10), :expand => true, :fill => true, :padding => 0)
		end
		return starBox
	end

	def draw_pixel(cr, value, column , line, width, height)
		cr.set_source_rgb(value,value,value)
		cr.rectangle(column, line, width, height)
		cr.fill
	end

	def drawPreview(grid)
		surface = Cairo::ImageSurface.new(50, 50)
		@cr = Cairo::Context.new(surface)

		width = 50 / grid.columns
		height = 50 / grid.lines

		grid.each_cell_with_index do |cell, line, column|
			case cell.state
			when Cell::CELL_BLACK
				draw_pixel(@cr,0,column*width,line*height,width,height)
			when Cell::CELL_WHITE
				draw_pixel(@cr,255,column*width,line*height,width,height)
			when Cell::CELL_CROSSED
				draw_pixel(@cr,255,column*width,line*height,width,height)
			end
		end

		pixBuf = AssetsLoader.pixbufFromSurface(surface)
		return AssetsLoader.imageFromPixbuf(pixBuf)
	end
end
