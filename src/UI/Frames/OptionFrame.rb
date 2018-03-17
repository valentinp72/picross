require 'yaml'

require_relative 'HomeFrame'
require_relative 'Game/GameFrame'

require_relative '../Frame'

##
# File          :: OptionFrame.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
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
		self.border_width = 100

		@user = user
		@redirectFrame = redirectFrame

		# create the settings
		@settings = createSettings
		@buttons  = createButtons

		@panel = Gtk::Box.new(:vertical)
	
		@settings.each do |setting|
			@panel.pack_start(setting, :expand => true, :fill => true, :padding => 5)
		end
		@panel.pack_start(@buttons)

		add(@panel)
	end

	##
	# Create the settings area of the frame
	# * *Returns* :
	#   - an Array of Setting for every setting we want to be in the frame
	def createSettings
		settings = []

		settings.push(SettingLanguage.new(@user))
		settings.push(SettingHypothesesColor.new(@user))

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

##
# This class represents the OptionFrame, page where we can change current user's settings
# This is called during a game, it then redirect the user to it's game

class GameOptionFrame < OptionFrame


	def initialize(user, chapter, map)
		super(user)
		@chapter = chapter
		@map     = map
	end

	def closeOrComeBackToHome(user)
		if self.parent.mainWindow? then
			self.parent.setFrame(GameFrame.new(user,@chapter,@map))
		else
			self.parent.close
		end
	end

end
class Setting < Gtk::Box

	def initialize(text, widget)
		super(:horizontal, 2)

		label = Gtk::Label.new(text)
		
		self.pack_start(label, :expand => true, :fill => true)
		self.pack_start(widget)
	end

	def save
		raise NotImplementedError, "a Setting needs to know what to do when saving" 
	end

end

class SettingLanguage < Setting

	def initialize(user)
		@user = user
	
		@selection = Gtk::ComboBoxText.new
		langs = self.retrieveLanguages
		langs.each do |l|
			@selection.append_text(l)
		end
		# Set default value to the current use language
		@selection.set_active(langs.index(user.settings.language))

		super(@user.lang["option"]["chooseLanguage"], @selection)
	end

	def save
		if @selection.active_text != nil
			@user.settings.language = @selection.active_text
		end
		return self
	end

	##
	# This function retrieve all available languages 
	def retrieveLanguages()
		path = File.dirname(__FILE__) + "/../../../Config/"
		return Dir.entries(path).select { |f| f.match(/lang\_(.*)/) }.select{ |x| x.slice!(0, 5) }
	end

end

class SettingHypothesesColor < Setting

	def initialize(user)
		@user = user

		@colors = Gtk::Box.new(:vertical)

		@colorsChoosers = [
			SettingHypothesisColor.new(user, 0),
			SettingHypothesisColor.new(user, 1),
			SettingHypothesisColor.new(user, 2),
			SettingHypothesisColor.new(user, 3),
			SettingHypothesisColor.new(user, 4)
		]
		@colorsChoosers.each do |colorChooser|
			@colors.pack_start(colorChooser, :padding => 5)
		end

		super(@user.lang["option"]["chooseHypColors"], @colors)
	end

	def save
		@colorsChoosers.each do |colorChooser|
			colorChooser.save
		end
	end

end

class SettingHypothesisColor < Setting

	def initialize(user, id)
		@user = user
		@id   = id

		@color = Gtk::ColorButton.new
		@color.color = Gdk::Color.parse(@user.settings.hypothesesColors[id])
		
		super(@user.lang["option"]["chooseHypColor"][id], @color)
#self.set_size_request(100, 10)
	end

	def save
		@user.settings.hypothesesColors[@id] = self.to_hex_color
	end

	def to_hex_color
		hex_by_12 = @color.color.to_s[1..-1]
		hex_by_6  = ""

		hex_by_12.scan(/.{4}/).each do |subcolor|
			hex_by_6 += subcolor[0..1]
		end
		return "#" + hex_by_6
	end

end

