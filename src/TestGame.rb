#!/usr/bin/env ruby
require 'gtk3'

#require_relative 'PicrossZone'

class Application < Gtk::Application
	
	def initialize
		super("pw.vlntn.picross.rubycross", [:handles_open])

		signal_connect "activate" do |application|
			window = GameWindow.new(application)
			window.present
		end

		signal_connect "startup" do |application|
			builder = Gtk::Builder.new()
			builder.add_from_file("app-menu.ui")
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
		preferences = PreferencesWindow.new(self)
		preferences.present
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

class Window < Gtk::ApplicationWindow
	
	def initialize(application)
		super(application)
		show_all
	end

end

class GameWindow < Window

	def initialize(application)
		super(application)
		set_title "Ruþycross"
		resize(600, 500)
		set_window_position :center

		@area = Gtk::DrawingArea.new

		@area.signal_connect "draw" do  
			cr = @area.window.create_cairo_context
			
			cr.set_source_rgb 0.2, 0.23, 0.9
			cr.rectangle 10, 15, 90, 60
			cr.fill

			cr.set_source_rgb 0.9, 0.1, 0.1
			cr.rectangle 130, 15, 90, 60
			cr.fill

			cr.set_source_rgb 0.4, 0.9, 0.4
			cr.rectangle 250, 15, 90, 60
			cr.fill

		end
		
		add(@area)
		@area.show
	end

end

class PreferencesWindow < Window

	def initialize(application)
		super(application)
		set_title "Preferences"
	end

end

application = Application.new
application.run([$0]+ARGV)
