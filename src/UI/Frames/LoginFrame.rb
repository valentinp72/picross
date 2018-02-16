require_relative '../Frame'

class LoginFrame < Frame

	def initialize()
		super()
		self.border_width = 100

		@btn_login = Gtk::Button.new(:label => "Log-In")
		@btn_login.set_size_request 70, 30

		@btn_login.signal_connect("clicked") do
			self.parent.setFrame(GameFrame.new(Map.load('../planet.map')))
		end
		add(@btn_login)
	end

end
