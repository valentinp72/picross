require 'yaml'
require_relative 'GameFrame'
require_relative 'OptionFrame'
require_relative '../Frame'

class HomeFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		#Retrieve user's language
		lang = user.settings.language
		configFile = File.expand_path(File.dirname(__FILE__) + '/' + "../../../Config/lang_#{lang}")
		config = YAML.load(File.open(configFile))



		@vbox = Gtk::Box.new(:vertical, 5)

		@playBtn = Gtk::Button.new(:label => config["home"]["play"])
		@rankBtn = Gtk::Button.new(:label => config["home"]["rank"])
		@ruleBtn = Gtk::Button.new(:label => config["home"]["rule"])
		@optiBtn = Gtk::Button.new(:label => config["home"]["option"])
		@exitBtn = Gtk::Button.new(:label => config["button"]["exit"])

		@vbox.pack_start(@playBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@rankBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@ruleBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@optiBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@exitBtn, :expand => true, :fill => true, :padding =>2)

		@playBtn.signal_connect("clicked") do
			tmpMapPath = File.expand_path(File.dirname(__FILE__) + '/../../map.tmp/planet.map')
			self.parent.setFrame(GameFrame.new(Map.load(tmpMapPath)))
		end

		@optiBtn.signal_connect("clicked") do
			self.parent.setFrame(OptionFrame.new(user))
		end

		@exitBtn.signal_connect("clicked") do
				Gtk.main_quit
		end

		#Add vbox to frame
		add(@vbox)

	end
end
