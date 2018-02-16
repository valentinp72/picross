require_relative '../Window'

class MainWindow < Window

	def initialize(application)
		super(application)
		set_title "Ruþycross"
		resize(600, 600)
		set_size_request 600, 600
		set_window_position :center
	end

end
