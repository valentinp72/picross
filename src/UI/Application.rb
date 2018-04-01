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

	# The minimum version of GTK for the application
	MIN_REQUIRED_VERSION = {"major" => 4, "minor" => 22, "micro" => 0}
	ACTUAL_VERSION = {
		"major" => Gtk.major_version, 
		"minor" => Gtk.minor_version, 
		"micro" => Gtk.micro_version
	}

	# The connected user, if any
	attr_reader :connectedUser
	attr_writer :connectedUser

	# The current window of the application
	attr_reader :window

	##
	# Create a new Application. If the current GTK version is not greater or equal than
	# the specified MIN_REQUIRED_VERSION, then the application will show a message
	# warning the user about it.
	def initialize
		super("pw.vlntn.picross.rubycross", [:handles_open])
		showErrorVersion if not versionCorrect?

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

	##
	# Returns true if the current GTK version is greater or 
	# equal to the specified minimum version (MIN_REQUIRED_VERSION).
	# * *Returns* :
	#   - true if the version is correct, false otherwise
	def versionCorrect?()
		["major", "minor", "micro"].each do |release|
			return true  if ACTUAL_VERSION[release] > MIN_REQUIRED_VERSION[release]
			return false if ACTUAL_VERSION[release] < MIN_REQUIRED_VERSION[release] 
		end
		return true
	end

	def showErrorVersion()
		d = Gtk::MessageDialog.new(
			:type    => Gtk::MessageType::ERROR,
			:buttons => Gtk::ButtonsType::OK_CANCEL,
			:message => self.versionErrorMessage
		)
		response = d.run
		d.destroy
		if response == Gtk::ResponseType::OK then
			# we continue the game, but this is dangerous
		else
			# we stop here
			self.action_quit_cb
		end
	end

	def versionErrorMessage
		messages = ""
		User.languagesName.each do |langName|
			messages += "\n" + errorMessage(langName) + "\n"
		end
		return messages
	end

	def errorMessage(langName)
		lang  = User.loadLang(langName)
		cur   = to_s_version(ACTUAL_VERSION) 
		req   = to_s_version(MIN_REQUIRED_VERSION)
		error = lang["versionError"].gsub("{{CURRENT}}", cur).gsub("{{REQUIRED}}", req)
		return lang["names"]["long"] + " : " + error 
	end

	def to_s_version(versionHash)
		return "#{versionHash["major"]}.#{versionHash["minor"]}.#{versionHash["micro"]}"
	end

end

