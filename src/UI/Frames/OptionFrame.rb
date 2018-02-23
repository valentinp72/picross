require 'yaml'

require_relative 'HomeFrame'
require_relative '../Frame'

##
# File          :: OptionFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the OptionFrame, page where we can change current user's settings
class OptionFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		# Retrieve user's language
		lang = user.settings.language
		# set path to config file folder
		@path = File.dirname(__FILE__) + '/' + "../../../Config/"
		# Retrieve associated language config file
		configFile = File.expand_path(@path + "lang_#{lang}")
		config = YAML.load(File.open(configFile))

		# Create label
		@langLabel = Gtk::Label.new(config["option"]["chooseLanguage"])

		# Create comboBox containing all available languages
		@comboBox = Gtk::ComboBoxText.new
		langs = retrieveLanguage
		langs.each{|u| @comboBox.append_text(u)}
		# Set default value to the current use language
		@comboBox.set_active(langs.index(lang))

		# Add cancel and valid buttons
		@cancelBtn = Gtk::Button.new(:label => config["button"]["cancel"])
		@validBtn = Gtk::Button.new(:label => config["button"]["valid"])

		# Create horizontal box containing 2 boxes
		@hbox = Gtk::Box.new(:horizontal, 2)
		@hbox.pack_start(@cancelBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@validBtn, :expand => true, :fill => true, :padding =>2)

		# Create vertical box containing 3 boxes
		@vbox = Gtk::Box.new(:vertical, 3)
		@vbox.pack_start(@langLabel, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)

		# Cancel -> We return to home
		@cancelBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		# Valid -> We return to home, but we change settings
		@validBtn.signal_connect("clicked") do
			if(@comboBox.active_text != nil) then
					# Change language
					user.settings.language= @comboBox.active_text
					self.parent.setFrame(HomeFrame.new(user))
			end
		end

		#Add vbox to frame
		add(@vbox)
	end

	##
	# This function retrieve all languages available
	def retrieveLanguage()
		return Dir.entries(@path).select { |f| f.match(/lang\_(.*)/)}.select{|x| x.slice!(0,5)}
	end

end
