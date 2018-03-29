require 'gtk3'

require_relative '../Map'

require_relative 'Window'
require_relative 'Windows/MainWindow'
require_relative 'Windows/PreferencesWindow'
require_relative 'Windows/AboutWindow'

require_relative 'Frame'
require_relative 'Frames/Game/GameFrame'
require_relative 'Frames/LoginFrame'

##
# File          :: Application.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
# This class represents the main GTK application. This inherits from a Gtk::Application.

class Application < Gtk::Application

	# The connected user, if any
	attr_reader :connectedUser
	attr_writer :connectedUser

	# The current window of the application
	attr_reader :window

	##
	# Create a new Application
	def initialize
		super("pw.vlntn.picross.rubycross", [:handles_open])

#puts Gtk::get_major_version
		puts Gtk.major_version, Gtk.minor_version, Gtk.micro_version

		@connectedUser = nil
		@window        = nil

		signal_connect "activate" do |application|
			@window = MainWindow.new(application)
			@window.setFrame(LoginFrame.new)
			@window.present
			@window.show_all

			# Bidouille pour que la fenêtre se mette au premier plan sur macOS
			# @window.set_keep_above(true)

		end

		signal_connect "startup" do |application|
			builder = Gtk::Builder.new()
			appmenuPath = File.expand_path(File.dirname(__FILE__) + '/app-menu.ui')
			builder.add_from_file(appmenuPath)
			set_app_menu(builder.get_object("appmenu"))
			set_menubar(builder.get_object("menubar"))
		end

		addAllActions(["about", "preferences", "quit", "close"])
	end

	##
	# Add all the actions to the application from the given list.
	# All action should have a method called +action_ACTIONNAME_cb+ specially for it.
	# * *Arguments* :
	#   - +actionsList+ -> the Array containing the actions
	# * *Returns* :
	#   - the object itself
	def addAllActions(actionsList)
		actionsList.each do |actionName|
			action = Gio::SimpleAction.new(actionName)
			action.signal_connect("activate") do |_action, parameter|
				mth = self.method("action_" + actionName + "_cb")
				mth.call()
			end
			add_action(action)
		end
		return self
	end

	##
	# The action when we want information about the application
	# * *Returns* :
	#   - the object itself
	def action_about_cb()
		about = AboutWindow.new(self)
		about.show_all
	end

	##
	# The action when we want to change preferences about the application
	# * *Returns* :
	#   - the object itself
	def action_preferences_cb()
		if @connectedUser != nil then
			preferences = PreferencesWindow.new(self)
			preferences.present
		else
			d = Gtk::MessageDialog.new(
					:parent  => @window, 
					:flags   => Gtk::DialogFlags::DESTROY_WITH_PARENT,
					:type    => Gtk::MessageType::WARNING,
					:buttons => Gtk::ButtonsType::OK,
					:message => "Cannot open preferences util you are connected"
			)
			d.run
			d.destroy
		end
	end

	##
	# The action when we want to quit the application
	# * *Returns* :
	#   - the object itself
	def action_quit_cb()
		quit
	end

	##
	# The action when we want to close the window
	# * *Returns* :
	#   - the object itself
	def action_close_cb()
		windows.each do |w|
			if w.has_toplevel_focus? then
				w.destroy
			end
		end
	end

end

