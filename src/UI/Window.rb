require_relative 'AssetsLoader'

class Window < Gtk::ApplicationWindow

	def initialize(application)
		super(application)
<<<<<<< HEAD
		testIcon = File.expand_path(File.dirname(__FILE__) + "/../assets/logo.png")
=======
		testIcon = AssetsLoader.loadFile('logo.png') 
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
		self.set_icon_from_file(testIcon)
	end

	def setFrame(frame)
		self.each do |child|
			self.remove(child)
		end
		self.child = frame
		frame.show_all
		@frame = frame

<<<<<<< HEAD
=======
	end

	def mainWindow?()
		return false
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	end

end
