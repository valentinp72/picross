require 'yaml'

require_relative 'HomeFrame'
require_relative '../Frame'

class OptionFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		#Retrieve user's language
		lang = user.settings.language
		@path = File.dirname(__FILE__) + '/' + "../../../Config/"
		configFile = File.expand_path(@path + "lang_#{lang}")
		config = YAML.load(File.open(configFile))

		@vbox = Gtk::Box.new(:vertical, 3)
		@hbox = Gtk::Box.new(:horizontal, 2)

		@langLabel = Gtk::Label.new(config["option"]["chooseLanguage"])


		@comboBox = Gtk::ComboBoxText.new
		langs = retrieveLanguage
		langs.each{|u| @comboBox.append_text(u)}
		# Set default value to the current use language
		@comboBox.set_active(langs.index(lang))

		@cancelBtn = Gtk::Button.new(:label => config["button"]["cancel"])
		@validBtn = Gtk::Button.new(:label => config["button"]["valid"])
		@hbox.pack_start(@cancelBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@validBtn, :expand => true, :fill => true, :padding =>2)

		@vbox.pack_start(@langLabel, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)

		@cancelBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		@validBtn.signal_connect("clicked") do
			if(@comboBox.active_text != nil) then
					user.settings.language= @comboBox.active_text
					self.parent.setFrame(HomeFrame.new(user))
			end
		end

		#Add vbox to frame
		add(@vbox)
	end

	def retrieveLanguage()
		return Dir.entries(@path).select { |f| f.match(/lang\_(.*)/)}.select{|x| x.slice!(0,5)}
	end

end
