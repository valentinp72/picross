require_relative 'AssetsLoader'

require_relative '../Picross'

class Window < Gtk::ApplicationWindow

	attr_reader :picross

	def initialize(application)
		super(application)
		@picross = Picross.new()
		testIcon = AssetsLoader.loadFile('logo.png')
		self.set_icon_from_file(testIcon)
		self.window_position = :center
		self.keyListener
	end

	def setFrame(frame)
		self.children.each do |child|
			if defined? child.removeFrame then
				child.removeFrame
			end
		end
		self.add(frame)
		frame.show_all
		@frame = frame
	end

	def mainWindow?()
		return false
	end

	def setKeyListener(keyValue, pressMethod: nil, releaseMethod: nil)
		if pressMethod != nil then
			@keysPress[keyValue] = pressMethod
		end
		if releaseMethod != nil then
			@keysRelease[keyValue] = releaseMethod
		end
	end

	def unsetKeyListener(keyValue)
		@keysPress.delete(keyValue)
		@keysRelease.delete(keyValue)
	end

	def keyListener()
		@keysPress   = Hash.new
		@keysRelease = Hash.new
		self.add_events(Gdk::EventMask::KEY_PRESS_MASK |
		                Gdk::EventMask::KEY_RELEASE_MASK)

		self.signal_connect("key-press-event") do |w, e|
			if @keysPress.has_key?(e.keyval) then
				@keysPress[e.keyval].call()
			end
		end
		self.signal_connect("key-release-event") do |w, e|
			if @keysRelease.has_key?(e.keyval) then
				@keysRelease[e.keyval].call()
			end
		end
	end

end
