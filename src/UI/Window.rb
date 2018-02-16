require 'Application'

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
