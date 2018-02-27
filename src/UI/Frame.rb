require_relative '../Picross'

class Frame < Gtk::Frame

	def initialize()
		super()
		@picross = Picross.new()
#self.resize_mode = Gtk::ResizeMode::QUEUE
#self.resize_mode = Gtk::ResizeMode::QUEUE
		self.shadow_type = Gtk::ShadowType::NONE
	end

end
