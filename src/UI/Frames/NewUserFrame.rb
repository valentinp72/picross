require 'yaml'

require_relative '../Frame'
require_relative 'HomeFrame'

class NewUserFrame < Frame

	def initialize()
		super()
		self.border_width = 100

		config = YAML.load(File.open("../../Config/lang_english"))
		@path = "../../Users"

		@vbox = Gtk::Box.new(:vertical, 3)
		@hbox = Gtk::Box.new(:horizontal, 2)

		@userLabel = Gtk::Label.new("Enter username")

		@entry = Gtk::Entry.new

		@cancelBtn = Gtk::Button.new(:label => config["button"]["cancel"])
		@validBtn = Gtk::Button.new(:label => config["button"]["valid"])

		@hbox.pack_start(@cancelBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@validBtn, :expand => true, :fill => true, :padding =>2)

		@vbox.pack_start(@userLabel, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@entry, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)

		@cancelBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		@validBtn.signal_connect("clicked") do
			if(@entry.text != nil) then
				if(@entry.text.match(/[a-zA-Z0-9_]*/) ) then
					user = User.new(@entry.text)
					user.save()
					self.parent.setFrame(HomeFrame.new(user))
				end
			end
		end


		#Add vbox to frame
		add(@vbox)
	end

	def retrieveLanguage()
		return Dir.entries(@path).select { |f| f.match(/lang\_(.*)/)}.select{|x| x.slice!(0,5)}
	end

end
