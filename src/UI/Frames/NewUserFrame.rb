require 'yaml'

require_relative '../Frame'
require_relative 'HomeFrame'
require_relative 'LoginFrame'

##
# File          :: NewUserFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the NewUserFrame, page where we can create a new user
class NewUserFrame < Frame

	def initialize()
		super()
		self.border_width = 100

		#Retrieve lang_english (Login is always in english)
		configFile = File.expand_path(File.dirname(__FILE__) + '/' + "../../../Config/lang_english")
		config = YAML.load(File.open(configFile))

		# Create label
		@userLabel = Gtk::Label.new("Enter username")

		# Create entry to input new username
		@entry = Gtk::Entry.new

		# Add cancel and valid buttons
		@cancelBtn = Gtk::Button.new(:label => config["button"]["cancel"])
		@validBtn = Gtk::Button.new(:label => config["button"]["valid"])

		# Create horizontalbox containing 2 boxes
		@hbox = Gtk::Box.new(:horizontal, 2)
		@hbox.pack_start(@cancelBtn, :expand => true, :fill => true, :padding =>2)
		@hbox.pack_start(@validBtn, :expand => true, :fill => true, :padding =>2)

		# Create vertical box containing 3 boxes
		@vbox = Gtk::Box.new(:vertical, 3)
		@vbox.pack_start(@userLabel, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@entry, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@hbox, :expand => true, :fill => true, :padding =>2)

		# Cancel -> We return to login
		@cancelBtn.signal_connect("clicked") do
			self.parent.setFrame(LoginFrame.new())
		end

		# Valid -> We create the new user and login directly with it
		@validBtn.signal_connect("clicked") do
			# Check if entry is not nil
			if(@entry.text != nil) then
				# Check if the user already exist?
				if(retrieveUser.include? @entry.text )
					# Check if entry only contains letters, numbers and "_"
					if(@entry.text.match(/[a-zA-Z0-9_]*/) ) then
						user = User.new(@entry.text)
						user.save()
						self.parent.setFrame(HomeFrame.new(user))
					end
				end
			end
		end

		##
		# This function retrieve all user available
		def retrieveUser()
			return Dir.entries(File.dirname(__FILE__) + '/' + "../../../Users/").select { |f| f.match(/User\_(.*)/)}.select{|x| x.slice!(0,5)}
		end

		#Add vbox to frame
		add(@vbox)
	end
end
