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
		@playerBtn = createPlayerButton(user)
		@globalBtn = createGlobalButton(user)

		@scrolled = Gtk::ScrolledWindow.new
		@scrolled.set_policy(:never, :automatic)

		@listbox = Gtk::ListBox.new
		@scrolled.add(@listbox)

		@container = createMainLayout(user)

		@playerHeader = Gtk::Box.new(:horizontal)
		@playerHeader.set_homogeneous(true)

		@globalBtn.clicked
		# Add vbox to frame
		add(@container)
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
		@container.pack_start(@playerHeader, :expand => false, :fill => true, :padding =>2)
		@container.reorder_child(@playerHeader,2)
	end

	def removePlayerScrollHeader()
		if(@playerHeader.parent == @container) then
			@container.remove(@playerHeader)
		end
	end

	def createPlayerScrollData(lvl)
		box = Gtk::Box.new(:horizontal)
		box.set_homogeneous(true)
		box.pack_start(Gtk::Label.new(lvl.name),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.maxStars.numberOfStars.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.bestTime.time.elapsedTime),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.minHelp.usedHelp.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.minClick.nbClick.to_s),:expand => true, :fill => true, :padding =>2)
		box.pack_start(Gtk::Label.new(lvl.allStat.nbFinished.to_s),:expand => true, :fill => true, :padding =>2)
		@listbox.add(box)
	end

	def calculatePlayerStat(user)
		i = 1
		# Loop over each Map of the user
		user.chapters.each do |chap|
			chap.levels.each do |lvl|
				if(lvl.allStat.length != 0)
					createPlayerScrollData(lvl)
					i += 1
				end
			end
		end
		return i
	end

	def createPlayerButton(user)
		button = Gtk::Button.new(:label => @lang["stats"]["player"])
		button.signal_connect("clicked") do
			reset(@listbox)
			createPlayerScrollHeader()

			i = calculatePlayerStat(user)

			# If i = 1 it means that there is no stat recorded for that user
			if(i == 1) then
				box = Gtk::Box.new(:horizontal)
				box.set_homogeneous(true)
				box.pack_start(Gtk::Label.new(@lang["stats"]["empty"]),:expand => true, :fill => true, :padding =>2)
			end
			@listbox.show_all
		end
		return button
	end

	def calculateGlobalStat(user)
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

					totalFinished += 1 if stat.isFinished == true
				end
			end
		end
		return [totalClick, totalTime, totalHelp , totalFinished]
	end

	def createGlobalButton(user)
		button = Gtk::Button.new(:label => @lang["stats"]["globals"])

		# Redirecting user towards option menu
		button.signal_connect("clicked") do
			reset(@listbox)
			removePlayerScrollHeader()

			totalClick, totalTime, totalHelp , totalFinished = calculateGlobalStat(user)

			createGlobalScroll(@lang["stats"]["global"]["stars"], user.totalStars.to_s)
			createGlobalScroll(@lang["stats"]["global"]["time"], totalTime.to_s)
			createGlobalScroll(@lang["stats"]["global"]["help"], totalHelp.to_s)
			createGlobalScroll(@lang["stats"]["global"]["click"], totalClick.to_s)
			createGlobalScroll(@lang["stats"]["global"]["finished"],totalFinished.to_s)
			@listbox.show_all
		end
		return button
	end

	def createMainLayout(user)

		@hbox = Gtk::Box.new(:horizontal)
		@hbox.pack_start(@playerBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@globalBtn, :expand => true, :fill => true, :padding =>2)

		@returnBtn = Gtk::Button.new()
		@returnBtn.image = AssetsLoader.loadImage("arrow-left.png", 40)
		@returnBtn.relief = Gtk::ReliefStyle::NONE

		# Redirecting user towards home
		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		box = Gtk::Box.new(:vertical)
		box.pack_start(@returnBtn, :expand => false, :fill => true, :padding =>2)
		box.pack_start(@hbox, :expand => false, :fill => true, :padding =>2)
		box.pack_start(@scrolled, :expand => true, :fill => true, :padding =>2)
	end
end
