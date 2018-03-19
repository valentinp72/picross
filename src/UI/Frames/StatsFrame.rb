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
		@lang = user.lang

		# Create 5 button
		@playerBtn = Gtk::Button.new(:label => @lang["stats"]["player"])
		@globalBtn = Gtk::Button.new(:label => @lang["stats"]["globals"])
		@returnBtn = Gtk::Button.new(:label => @lang["button"]["return"])

		@hbox = Gtk::Box.new(:horizontal)
		@hbox.pack_start(@playerBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@globalBtn, :expand => true, :fill => true, :padding =>2)

		@grid = Gtk::Grid.new()
		@grid.set_column_homogeneous(true)

		@vbox = Gtk::Box.new(:vertical)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@grid, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@returnBtn, :expand => true, :fill => true, :padding =>2)

		@playerBtn.signal_connect("clicked") do
			resetGrid(@grid)
			i = 1
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["level"]),0,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["stars"]),1,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["time"]),2,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["help"]),3,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["click"]),4,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["local"]["finished"]),5,0,1,1)
			user.chapters.each do |chap|
				chap.levels.each do |lvl|
					if(lvl.allStat.length != 0)
						@grid.attach(Gtk::Label.new(lvl.name),0,i,1,1)
						@grid.attach(Gtk::Label.new(lvl.allStat.maxStars.numberOfStars.to_s),1,i,1,1)
						@grid.attach(Gtk::Label.new(lvl.allStat.bestTime.time.elapsedTime),2,i,1,1)
						@grid.attach(Gtk::Label.new(lvl.allStat.minHelp.useHelp.to_s),3,i,1,1)
						@grid.attach(Gtk::Label.new(lvl.allStat.minClick.nbClick.to_s),4,i,1,1)
						@grid.attach(Gtk::Label.new(lvl.allStat.nbFinished.to_s),5,i,1,1)
						i += 1
					end
				end
			end
			if(i == 1) then
				@grid.attach(Gtk::Label.new(@lang["stats"]["empty"]),0,1,2,1)
			end
			@grid.show_all
		end

		# Redirecting user towards option menu
		@globalBtn.signal_connect("clicked") do
			resetGrid(@grid)

			totalClick = 0
			totalTime = 0
			totalHelp = 0
			totalStar = 0
			totalFinished = 0

			user.chapters.each do |chap|
				chap.levels.each do |lvl|
					lvl.allStat.each do |stat|
						totalClick += stat.nbClick
						totalTime += stat.time.elapsedSeconds
						totalHelp += stat.usedHelp
						totalStar += stat.numberOfStars
						totalFinished += 1 if stat.isFinished == true
					end
				end
			end

			@grid.attach(Gtk::Label.new(@lang["stats"]["global"]["stars"]),0,0,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["global"]["time"]),0,1,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["global"]["help"]),0,2,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["global"]["click"]),0,3,1,1)
			@grid.attach(Gtk::Label.new(@lang["stats"]["global"]["finished"]),0,4,1,1)

			@grid.attach(Gtk::Label.new(totalStar.to_s),1,0,1,1)
			@grid.attach(Gtk::Label.new(totalTime.to_s),1,1,1,1)
			@grid.attach(Gtk::Label.new(totalHelp.to_s),1,2,1,1)
			@grid.attach(Gtk::Label.new(totalClick.to_s),1,3,1,1)
			@grid.attach(Gtk::Label.new(totalFinished.to_s),1,4,1,1)

			@grid.show_all

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
		grid.children.each do |child|
			grid.remove(child)
		end
	end

end
