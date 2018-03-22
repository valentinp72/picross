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

		# Create 3 button
		@playerBtn = Gtk::Button.new(:label => @lang["stats"]["player"])
		@globalBtn = Gtk::Button.new(:label => @lang["stats"]["globals"])

		@returnBtn = Gtk::Button.new()
		@returnBtn.image = AssetsLoader.loadImage("arrow-left.png", 40)
		@returnBtn.relief = Gtk::ReliefStyle::NONE

		@hbox = Gtk::Box.new(:horizontal)
		@hbox.pack_start(@playerBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@globalBtn, :expand => true, :fill => true, :padding =>2)

		@scrolled = Gtk::ScrolledWindow.new
		@scrolled.set_policy(:never, :automatic)

		@vbox = Gtk::Box.new(:vertical)
		@vbox.pack_start(@returnBtn, :expand => false, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => false, :fill => true, :padding =>2)
		@vbox.pack_start(@scrolled, :expand => true, :fill => true, :padding =>2)

		@listbox = Gtk::ListBox.new
		@scrolled.add(@listbox)

		@playerHeader = Gtk::Box.new(:horizontal)
		@playerHeader.set_homogeneous(true)

		@playerBtn.signal_connect("clicked") do
			i = 1
			reset(@listbox)
			createPlayerScrollHeader()

			# Loop over each Map of the user
			user.chapters.each do |chap|
				chap.levels.each do |lvl|
					if(lvl.allStat.length != 0)
						createPlayerScrollData(lvl)
						i += 1
					end
				end
			end

			# If i = 1 it means that there is no stat recorded for that user
			if(i == 1) then
				box = Gtk::Box.new(:horizontal)
				box.set_homogeneous(true)
				box.pack_startattach(Gtk::Label.new(@lang["stats"]["empty"]),:expand => true, :fill => true, :padding =>2)
			end
			@listbox.show_all
		end

		# Redirecting user towards option menu
		@globalBtn.signal_connect("clicked") do
			reset(@listbox)
			removePlayerScrollHeader()

			totalClick = 0
			totalTime = 0
			totalHelp = 0
			totalStar = 0
			totalFinished = 0

			# Loop over each Map of the user
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

			createGlobalScroll(@lang["stats"]["global"]["stars"], totalStar.to_s)
			createGlobalScroll(@lang["stats"]["global"]["time"], totalTime.to_s)
			createGlobalScroll(@lang["stats"]["global"]["help"], totalHelp.to_s)
			createGlobalScroll(@lang["stats"]["global"]["click"], totalClick.to_s)
			createGlobalScroll(@lang["stats"]["global"]["finished"],totalFinished.to_s)
			@listbox.show_all
		end

		# Redirecting user towards home
		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		# Add vbox to frame
		add(@vbox)
	end

	##
	# This methods reset a widget
	def reset(widget)
		widget.children.each do |child|
			widget.remove(child)
		end
	end

	def createGlobalScroll(labelString, value)
		box = Gtk::Box.new(:horizontal)
		box.set_homogeneous(true)
		box.pack_start(Gtk::Label.new(labelString),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(value),:expand => true, :fill => true, :padding =>2)
		@listbox.add(box)
	end


	def createPlayerScrollHeader()
		removePlayerScrollHeader()
		reset(@playerHeader)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["level"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["stars"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["time"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["help"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["click"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.pack_start(Gtk::Label.new(@lang["stats"]["local"]["finished"]),:expand => true, :fill => true, :padding =>2)
		@playerHeader.show_all
		@vbox.pack_start(@playerHeader, :expand => false, :fill => true, :padding =>2)
		@vbox.reorder_child(@playerHeader,2)
	end

	def removePlayerScrollHeader()
		if(@playerHeader.parent == @vbox) then
			@vbox.remove(@playerHeader)
		end
	end

	def createPlayerScrollData(lvl)
		box = Gtk::Box.new(:horizontal)
		box.set_homogeneous(true)
		box.pack_start(Gtk::Label.new(lvl.name),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.maxStars.numberOfStars.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.bestTime.time.elapsedTime),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.minHelp.useHelp.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.minClick.nbClick.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.nbFinished.to_s),:expand => true, :fill => true, :padding =>2)
		@listbox.add(box)
	end

end
