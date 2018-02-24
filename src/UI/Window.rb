require_relative 'AssetsLoader'

class Window < Gtk::ApplicationWindow

	def initialize(application)
		super(application)
		testIcon = AssetsLoader.loadFile('logo.png') 
		self.set_icon_from_file(testIcon)
	end

	def setFrame(frame)
		self.each do |child|
			self.remove(child)
		end
		self.child = frame
		frame.show_all
		@frame = frame

	end

	def mainWindow?()
		return false
	end

end
