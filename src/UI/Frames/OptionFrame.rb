require_relative 'HomeFrame'
require_relative 'Game/GameFrame'

require_relative '../Frame'

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
		settings.push(SettingKeyboard.new(@user))

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

class Setting

	attr_reader :label

	attr_reader :widget

	def initialize(text, widget)

		@label  = Gtk::Label.new(text)
		@widget = widget

		@label.halign  = Gtk::Align::START
		@widget.halign = Gtk::Align::END

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
			@selection.append_text(l.gsub(/\w+/, &:capitalize))
		end
		# Set default value to the current use language
		@selection.set_active(langs.index(user.settings.language))

		super(@user.lang["option"]["chooseLanguage"], @selection)
	end

	def save
		if @selection.active_text != nil
			@user.settings.language = @selection.active_text.downcase
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

		@colors = Gtk::Grid.new()
		@colors.column_spacing = 5

		@colorsChoosers = [
			SettingHypothesisColor.new(user, 0),
			SettingHypothesisColor.new(user, 1),
			SettingHypothesisColor.new(user, 2),
			SettingHypothesisColor.new(user, 3),
			SettingHypothesisColor.new(user, 4)
		]

		line = 0
		@colorsChoosers.each do |colorChooser|
			@colors.attach(colorChooser.label,  0, line, 1, 1)
			@colors.attach(colorChooser.widget, 1, line, 1, 1)
			line += 1
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

class SettingKeyboard < Setting
	def initialize(user)
		@user = user

		@keys = Gtk::Grid.new()
		@keys.column_spacing = 5

		@keyboardChoosers = [
			SettingKey.new(@user.lang["option"]["keyboard"]["up"], @user.settings.keyboardUp),
			SettingKey.new(@user.lang["option"]["keyboard"]["down"], @user.settings.keyboardDown),
			SettingKey.new(@user.lang["option"]["keyboard"]["left"], @user.settings.keyboardLeft),
			SettingKey.new(@user.lang["option"]["keyboard"]["right"], @user.settings.keyboardRight),
			SettingKey.new(@user.lang["option"]["keyboard"]["click-left"], @user.settings.keyboardClickLeft),
			SettingKey.new(@user.lang["option"]["keyboard"]["click-right"], @user.settings.keyboardClickRight)
		]

		line = 0
		@keyboardChoosers.each do |keyChooser|
			@keys.attach(keyChooser.label,  0, line, 1, 1)
			@keys.attach(keyChooser.widget, 1, line, 1, 1)
			line += 1
		end

		super(@user.lang["option"]["chooseKeyboard"],@keys)
	end
end


class SettingKey < Setting
	def initialize(optionName,value)
		@key = Gtk::Button.new(:label => Gdk::Keyval.to_name(value))
		super(optionName,@key)
	end
end
