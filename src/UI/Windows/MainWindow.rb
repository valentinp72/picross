require_relative '../Window'

class MainWindow < Window

	def initialize(application)
		super(application)
		set_title "Ruþycross"
<<<<<<< HEAD
#resize(600, 600)
		set_window_position :center
		override_background_color([:normal], Gdk::RGBA.new(4793, 4739, 10, 10))
=======
		set_window_position :center
		override_background_color([:normal], Gdk::RGBA.new(4793, 4739, 10, 10))
	end

	def mainWindow?()
		return true
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	end

end
