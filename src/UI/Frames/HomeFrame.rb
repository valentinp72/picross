require 'yaml'
require_relative 'ChapterFrame'
require_relative 'OptionFrame'
require_relative 'StatsFrame'

require_relative '../Frame'

##
# File          :: HomeFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the HomeFrame which is the main menu after the login
class HomeFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		@user = user

		self.draw
	end

	def draw
		lang = @user.lang
		
		# Create 5 button
		@playBtn = Gtk::Button.new(:label => lang["home"]["play"])
		@rankBtn = Gtk::Button.new(:label => lang["home"]["rank"])
		@ruleBtn = Gtk::Button.new(:label => lang["home"]["rule"])
		@optiBtn = Gtk::Button.new(:label => lang["home"]["option"])
		@exitBtn = Gtk::Button.new(:label => lang["button"]["exit"])

		# Create vertical box containing 5 boxes
		@vbox = Gtk::Box.new(:vertical, 5)
		@vbox.pack_start(@playBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@rankBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@ruleBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@optiBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@exitBtn, :expand => true, :fill => true, :padding =>2)

		@playBtn.signal_connect("clicked") do
			self.parent.setFrame(ChapterFrame.new(@user))
		end

		# Redirecting user towards option menu
		@optiBtn.signal_connect("clicked") do
			self.parent.setFrame(OptionFrame.new(@user, self))
		end

		# Redirecting user towards statistics menu
		@rankBtn.signal_connect("clicked") do
			self.parent.setFrame(StatsFrame.new(@user))
		end

		# Exit programms
		@exitBtn.signal_connect("clicked") do
			self.parent.application.action_quit_cb
		end

		# Add vbox to frame
		self.children.each do |child|
			self.remove(child)
		end
		add(@vbox)

	end

end
