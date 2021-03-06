require_relative '../Frame'
require_relative 'HomeFrame'
require_relative 'Game/GameFrame'

require_relative 'Settings/Setting'
require_relative 'Settings/SettingLanguage'
require_relative 'Settings/SettingHypothesesColor'
require_relative 'Settings/SettingKeyboard'

##
# File          :: OptionFrame.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 03/17/2018
# Version       :: 0.1
#
# This class represents the OptionFrame, page where we can change current user's settings

class OptionFrame < Frame

	##
	# Creation of the option frame
	# * *Arguments* :
	#   - +user+ -> the user that is editing his options
	def initialize(user, redirectFrame)
		super()
		self.border_width = 10

		@user = user
		@redirectFrame = redirectFrame

		# create the settings
		@settings = createSettings
		@buttons  = createButtons
		@panel    = createPanel

		self.signal_connect('size-allocate') do |widget, event|

		end

		self.add(@panel)
	end

	##
	# Create the main panel for the frame
	# * *Returns* :
	#   - the panel to be displayed
	def createPanel
		panel = Gtk::Grid.new()
		panel.row_spacing = 20
		panel.column_spacing = 10

		panel.attach(self.title, 0, 0, 2, 1)
		panel.attach(self.separator, 0, 1, 2, 1)
		line = 2
		@settings.each do |setting|
			panel.attach(setting.label,  0, line, 1, 1)
			panel.attach(setting.widget, 1, line, 1, 1)
			panel.attach(self.separator, 0, line + 1, 2, 1)
			line += 2
		end
		panel.attach(@buttons, 0, line, 2, 1)

		panel.halign = Gtk::Align::CENTER
		panel.valign = Gtk::Align::CENTER

		return panel
	end

	##
	# Returns a separator to be put between elements
	# * *Returns* :
	#   - a Gtk::Widget acting as a separator
	def separator
		return Gtk::Frame.new()
	end

	##
	# Returns a title for the frame
	# * *Returns* :
	#   - a Gtk::Label
	def title
		label = Gtk::Label.new()
		label.set_markup("<b><big>#{@user.lang["option"]["title"]}</big></b>")
		return label
	end

	##
	# Create the settings area of the frame
	# * *Returns* :
	#   - an Array of Setting for every setting we want to be in the frame
	def createSettings
		settings = []

		settings.push(SettingLanguage.new(@user))
		settings.push(SettingHypothesesColor.new(@user))
		settings.push(SettingKeyboard.new(@user, self))

		return settings
	end

	##
	# Create the buttons of the frame
	# * *Returns* :
	#   - a Gtk::Box containing all the buttons to be displayed on the frame
	def createButtons
		# Add cancel and valid buttons
		@cancelBtn = Gtk::Button.new(:label => @user.lang["button"]["cancel"])
		@validBtn  = Gtk::Button.new(:label => @user.lang["button"]["valid"])

		# Create horizontal box containing 2 boxes
		buttons = Gtk::Box.new(:horizontal, 2)
		buttons.pack_start(@cancelBtn, :expand => true, :fill => true, :padding =>2)
		buttons.pack_start(@validBtn,  :expand => true, :fill => true, :padding =>2)

		# Cancel -> We return to home
		@cancelBtn.signal_connect("clicked") do
			closeOrComeBackToHome(@user)
		end

		# Valid -> We return to home, but we change settings
		@validBtn.signal_connect("clicked") do
			@settings.each do |setting|
				setting.save
			end
			@user.save()
			closeOrComeBackToHome(@user)
		end

		return buttons
	end

	##
	# Ask for the frame to close the window, or to change
	# to the home frame.
	# * *Returns* :
	#   - the frame itself
	def closeOrComeBackToHome(user)
		if self.parent.mainWindow? then
#self.parent.setFrame(HomeFrame.new(user))
			@redirectFrame.draw
			self.parent.setFrame(@redirectFrame)
		else
			self.parent.close
		end
		return self
	end

end
