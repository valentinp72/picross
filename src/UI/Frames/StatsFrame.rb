require 'yaml'
require_relative 'HomeFrame'
require_relative '../Frame'

##
# File          :: StatsFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/24/2018
# Last update   :: 02/24/2018
# Version       :: 0.1
#
# This class represents the HomeFrame which is the main menu after the login
class StatsFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		# Retrieve user's language
		lang = user.settings.language
		# Retrieve associated language config file
		configFile = File.expand_path(File.dirname(__FILE__) + '/' + "../../../Config/lang_#{lang}")
		config = YAML.load(File.open(configFile))



		# Create 5 button
		@playerBtn = Gtk::Button.new(:label => config["stats"]["player"])
		@globalBtn = Gtk::Button.new(:label => config["stats"]["global"])
		@returnBtn = Gtk::Button.new(:label => config["button"]["return"])

		@hbox = Gtk::Box.new(:horizontal)
		@hbox.pack_start(@playerBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@globalBtn, :expand => true, :fill => true, :padding =>2)

		@grid = Gtk::Grid.new()

		@vbox = Gtk::Box.new(:vertical)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@grid, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@returnBtn, :expand => true, :fill => true, :padding =>2)



		@playerBtn.signal_connect("clicked") do
			resetGrid(@grid)
			@vbox.remove(@grid)
			i = 0
			@grid.attach(Gtk::Label.new("test"),0,0,1,1)
			@grid.attach(Gtk::Label.new("Temps : "),1,0,1,1)
			user.chapters.each do |chap|
				chap.levels.each do |lvl|
					lvl.allStat.each do |stat|
						puts "Stats"
						@grid.attach(Gtk::Label.new(lvl.name),0,i,1,1)
						@grid.attach(Gtk::Label.new("Temps : " + stat.time.elapsedTime),1,i,1,1)
						i += 1
					end
				end
			end
			@vbox.pack_start(@grid, :expand => true, :fill => true, :padding =>2)
			remove(@vbox)
			add(@vbox)

		end

		# Redirecting user towards option menu
		@globalBtn.signal_connect("clicked") do
			resetGrid(@grid)
		end

		# Redirecting user towards home
		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		# Add vbox to frame
		add(@vbox)
	end

	##
	# This methods reset a grid
	def resetGrid(grid)
		grid.each do |child|
			grid.remove(child)
		end
	end

end
