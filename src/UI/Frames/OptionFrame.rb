require 'yaml'

require_relative 'HomeFrame'
<<<<<<< HEAD
=======
require_relative 'Game/GameFrame'

>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
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
<<<<<<< HEAD
=======
# This can only be called from HomeFrame
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
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
<<<<<<< HEAD
			self.parent.setFrame(HomeFrame.new(user))
=======
			closeOrComeBackToHome(user)
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
		end

		# Valid -> We return to home, but we change settings
		@validBtn.signal_connect("clicked") do
			if(@comboBox.active_text != nil) then
					# Change language
<<<<<<< HEAD
					user.settings.language= @comboBox.active_text
					self.parent.setFrame(HomeFrame.new(user))
=======
					user.settings.language = @comboBox.active_text
					user.save()
					closeOrComeBackToHome(user)
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
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

<<<<<<< HEAD
=======
	def closeOrComeBackToHome(user)
		if self.parent.mainWindow? then
			self.parent.setFrame(HomeFrame.new(user))
		else
			self.parent.close
		end
	end

end

# This class represents the OptionFrame, page where we can change current user's settings
# This can only be called from GameFrame
class GameOptionFrame < OptionFrame

	def initialize(user,chapter,map)
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

>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
end
