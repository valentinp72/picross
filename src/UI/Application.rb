#!/usr/bin/env ruby
# encoding: utf-8

require 'gtk3'

require_relative '../Map'

require_relative 'Window'
require_relative 'Windows/MainWindow'
require_relative 'Windows/PreferencesWindow'

require_relative 'Frame'
require_relative 'Frames/Game/GameFrame'
require_relative 'Frames/LoginFrame'

class Application < Gtk::Application

	# The connected user, if any
	attr_reader :connectedUser
	attr_writer :connectedUser

	attr_reader :window

	def initialize
		super("pw.vlntn.picross.rubycross", [:handles_open])

		@connectedUser = nil
		@window        = nil

		signal_connect "activate" do |application|
			@window = MainWindow.new(application)
			@window.setFrame(LoginFrame.new)
			@window.present
			@window.show_all

			# Bidouille pour que la fenêtre se mette au premier plan sur macOS
			@window.set_keep_above(true)

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

	def addAllActions(actionsList)
		actionsList.each do |actionName|
			action = Gio::SimpleAction.new(actionName)
			action.signal_connect("activate") do |_action, parameter|
				mth = self.method("action_" + actionName + "_cb")
				mth.call()
			end
			add_action(action)
		end
	end

	def action_about_cb()

	end

	def action_preferences_cb()
		if @connectedUser != nil then
			preferences = PreferencesWindow.new(self)
			preferences.present
		end
	end

	def action_quit_cb()
		quit
	end

	def action_close_cb()
		windows.each do |w|
			if w.has_toplevel_focus? then
				w.destroy
			end
		end
	end

end

application = Application.new
application.run([$0]+ARGV)
