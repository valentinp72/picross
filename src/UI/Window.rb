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
		self.children.each do |child|
			#self.remove(child)
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
end
