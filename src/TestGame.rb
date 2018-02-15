#!/usr/bin/env ruby
require 'gtk3'

require_relative 'Map'
#require_relative 'PicrossZone'

class Application < Gtk::Application
	
	def initialize
		super("pw.vlntn.picross.rubycross", [:handles_open])

		signal_connect "activate" do |application|
			window = MainWindow.new(application)
			window.setFrame(LoginFrame.new())
			window.present
			window.show_all
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
	end

	def setFrame(frame)
		self.each do |child|
			self.remove(child)
		end
		self.child = frame
		frame.show_all
		@frame = frame
	end

end

class Frame < Gtk::Frame

	def initialize()
		super()
		self.resize_mode = Gtk::ResizeMode::QUEUE
		self.shadow_type = Gtk::ShadowType::NONE
	end

end

class LoginFrame < Frame

	def initialize()
		super()
		self.border_width = 100

		@btn_login = Gtk::Button.new(:label => "Log-In")
		@btn_login.set_size_request 70, 30

		@btn_login.signal_connect("clicked") do
			self.parent.setFrame(GameFrame.new(Map.load('test.map')))
		end
		add(@btn_login)
	end

end

class GameFrame < Frame

	def initialize(map)
		super()
		@area = Gtk::DrawingArea.new
		@grid = map.solution
		setGame()

		@area.signal_connect('button_press_event') do |draw, button|
#print "click '#{button.y}, #{button.x}' \n"
			userClickedAt(button.y, button.x)
		end

		@area.signal_connect('motion_notify_event') do |draw, motionEvent|#draw, button|
			if motionEvent.state.button1_mask? then
				# on a bougé en cliquant	
#print "click '#{motionEvent.y / @cellSize}, #{motionEvent.x / @cellSize}' \n"
				userClickedAt(motionEvent.y, motionEvent.x)
			end
		end

		@area.events |= (Gdk::EventMask::BUTTON_PRESS_MASK | 
		                 Gdk::EventMask::POINTER_MOTION_MASK) 

		@lastClickedX = nil
		@lastClickedY = nil
		@wantedState  = Cell::CELL_CROSSED
	end

	def userClickedAt(yPos, xPos)
		gridPosY = (yPos / @cellSize * 1000).floor / 1000.0
		gridPosX = (xPos / @cellSize * 1000).floor / 1000.0
		if gridPosX != @lastClickedX || gridPosY != @lastClickedY then
			begin
				@grid.getCellPosition(gridPosY, gridPosX).state = @wantedState
				@area.queue_draw
				@lastClickedY = gridPosY
				@lastClickedX = gridPosX
			rescue
				print "Invalid position"
			end
		end
	end

	def setGame()
		
		@area.signal_connect "draw" do
			cr = @area.window.create_cairo_context
			# GDK_comma	
			allowedW = self.parent.width_request
			allowedH = self.parent.height_request
		
			sizeX_tmp = allowedW / @grid.columns
			sizeY_tmp = allowedH / @grid.lines

			@cellSize = [sizeX_tmp, sizeY_tmp].min

			@grid.each_cell_with_index do |cell, j, i|
				posX = i * @cellSize
				posY = j * @cellSize
				
				case cell.state
					when Cell::CELL_BLACK
						cr.set_source_rgb 0.0, 0.0, 0.0
					when Cell::CELL_WHITE
						cr.set_source_rgb 1.0, 1.0, 1.0
					when Cell::CELL_CROSSED
						cr.set_source_rgb 0.8, 0.8, 0.8
					else
						cr.set_source_rgb 1.0, 0.0, 0.0
				end

				cr.rectangle(posX, posY, @cellSize, @cellSize)
				cr.fill
			end

		end
		
		@area.show
		add(@area)
	end

end

class MainWindow < Window

	def initialize(application)
		super(application)
		set_title "Ruþycross"
		resize(600, 600)
		set_size_request 600, 600
		set_window_position :center
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
