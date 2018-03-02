require_relative '../Frame'
require_relative 'HomeFrame'
require_relative 'NewUserFrame'
require_relative '../../User'
require_relative '../../Picross'

##
# File          :: LoginFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the LoginFrame which is the first page we encounter when we launch the application
class LoginFrame < Frame

	def initialize()
		super()
		self.border_width = 100

		# Set path variable to Users folder
		@path = File.expand_path(File.dirname(__FILE__) + '/' + '../../../Users')

		# Create a new comboBox which will hold all the username
		@comboBox = Gtk::ComboBoxText.new

		picross = Picross.new

		signal_connect "realize" do
			self.parent.picross.retrieveUser.each{|u| @comboBox.append_text(u)}
			@comboBox.set_active(0)
		end

		# Add a login button
		@loginBtn = Gtk::Button.new(:label => "Login")

		# Add a button to create a new user
		@createBtn = Gtk::Button.new(:label => "Create new account")

		# Add vertical box containing 3 boxes
		@vbox = Gtk::Box.new(:vertical, 3)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@loginBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@createBtn, :expand => true, :fill => true, :padding =>2)


		@loginBtn.signal_connect("clicked") do
			#The button login works only if a user is selected.
			if(@comboBox.active_text != nil) then
			user = self.parent.picross.getSelectedUser(@comboBox.active_text)
			self.parent.application.connectedUser = user
			self.parent.setFrame(HomeFrame.new(user))
			end
		end

		# Redirect to NewUserFrame if we want to create a new user
		@createBtn.signal_connect("clicked") do
			self.parent.setFrame(NewUserFrame.new())
		end

		# Add vbox to frame
		add(@vbox)
	end
end
