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

		self.add_events(Gdk::EventMask::KEY_PRESS_MASK)
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

	def addKeyBinding(method)
		self.signal_connect("key-press-event") do |w, e|
			method.call(e)
		end
	end
end
