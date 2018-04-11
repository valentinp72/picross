require 'yaml'
require_relative 'ChapterFrame'
require_relative 'OptionFrame'
require_relative 'StatsFrame'
require_relative 'RulesFrame'

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
		@lang = @user.lang

		@buttons = createButtons
		@grid    = createArea

		# Add vbox to frame
		self.children.each do |child|
			self.remove(child)
		end

		self.add(@grid)
	end

	def createButtons

		# Create the buttons
		@playBtn = Gtk::Button.new(:label => @lang["home"]["play"])
		@rankBtn = Gtk::Button.new(:label => @lang["home"]["rank"])
		@ruleBtn = Gtk::Button.new(:label => @lang["home"]["rule"])
		@optiBtn = Gtk::Button.new(:label => @lang["home"]["option"])
		@exitBtn = Gtk::Button.new(:label => @lang["button"]["exit"])

		# Redirecting user towards the list of chapters
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

		# Rules button
		@ruleBtn.signal_connect("clicked") do
			self.parent.setFrame(RulesFrame.new(@user))
		end

		# Exit programms
		@exitBtn.signal_connect("clicked") do
			self.parent.application.action_quit_cb
		end

		return [@playBtn, @rankBtn, @ruleBtn, @optiBtn, @exitBtn]
	end

	def createArea
		grid = Gtk::Grid.new()

		grid.row_spacing = 5
		grid.halign = Gtk::Align::CENTER
		grid.valign = Gtk::Align::CENTER

		grid.attach(self.title, 0, 0, 1, 1)

		line = 1
		@buttons.each do |button|
			grid.attach(button, 0, line, 1, 1)
			button.set_size_request(100, 20)
			line += 1
		end

		return grid
	end

	##
	# Returns a title for the frame
	# * *Returns* :
	#   - a Gtk::Label
	def title
		label = Gtk::Label.new()
		label.set_markup("<b><big>Ruþycross</big></b>")
		return label
	end

end
