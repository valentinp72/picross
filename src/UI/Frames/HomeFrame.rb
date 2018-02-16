require 'yaml'

require_relative '../Frame'

class HomeFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

<<<<<<< HEAD
		#Retrieve user's language
=======
		configFile = File.expand_path(File.dirname(__FILE__) + '/' + '../../config.yml')

		config = YAML.load(File.open(configFile))
>>>>>>> dev_appBuilding
		lang = user.settings.language
		config = YAML.load(File.open("../../Config/lang_#{lang}"))

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
		#Add vbox to frame
		add(@vbox)

	end
end
