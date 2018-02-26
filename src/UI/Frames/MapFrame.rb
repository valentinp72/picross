require 'yaml'
<<<<<<< HEAD
require_relative 'GameFrame'
=======
require_relative 'Game/GameFrame'
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
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

		# Retrieve user's language
		lang = user.settings.language
		# Retrieve associated language config file
		configFile = File.expand_path(File.dirname(__FILE__) + '/' + "../../../Config/lang_#{lang}")
		config = YAML.load(File.open(configFile))

		# Create vertical box containing all chapters buttons
		@vbox = Gtk::Box.new(:vertical, chapter.levels.length)

		# Create a return button
		@returnBtn = Gtk::Button.new(:label => config["button"]["return"])
		@vbox.pack_start(@returnBtn, :expand => true, :fill => true, :padding =>2)

		# List of bouttons
		@buttonsList = Array.new(chapter.levels.length + 1)

		0.upto(chapter.levels.length - 1)  do |x|
			@buttonsList[x] = Gtk::Button.new(:label => chapter.levels[x].name)
			@vbox.pack_start(@buttonsList[x], :expand => true, :fill => true, :padding =>2)

			@buttonsList[x].signal_connect("clicked") do
<<<<<<< HEAD
				self.parent.setFrame(GameFrame.new(chapter.levels[x]))
=======
				self.parent.setFrame(GameFrame.new(user,chapter,chapter.levels[x]))
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
			end
		end

		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(ChapterFrame.new(user))
		end

		# Add vbox to frame
		add(@vbox)
	end
end
