require 'yaml'

require_relative '../../User'
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

	def initialize(lang)
		super()
		self.border_width = 100
		@lang = lang

		# Create label
		@userLabel = Gtk::Label.new(@lang["newUser"]["username"])

		# Create entry to input new username
		@entry = Gtk::Entry.new

		# Add cancel and valid buttons
		@cancelBtn = Gtk::Button.new(:label => @lang["button"]["cancel"])
		@validBtn = Gtk::Button.new(:label => @lang["button"]["valid"])

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
			isOk, user = self.parent.picross.ajouteUser(@entry.text, @lang)
			if isOk then
				self.parent.setFrame(HomeFrame.new(user))
			else
				error = Gtk::MessageDialog.new(
					:parent  => self.parent, 
					:flags   => Gtk::DialogFlags::DESTROY_WITH_PARENT,
					:type    => Gtk::MessageType::ERROR,
					:buttons => Gtk::ButtonsType::OK,
					:message => @lang["newUser"]["alreadyTaken"]
			)
				error.run
				error.destroy
			end
		end


		#Add vbox to frame
		add(@vbox)
	end
end
