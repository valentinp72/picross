require_relative 'AssetsLoader'

require_relative '../Picross'

class Window < Gtk::ApplicationWindow

	attr_reader :picross

	def initialize(application)
		super(application)
		@picross = Picross.new()
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
