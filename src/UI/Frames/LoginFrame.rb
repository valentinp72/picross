require_relative '../Frame'

class LoginFrame < Frame

	def initialize()
		super()
		self.border_width = 100



		@comboBox = Gtk::ComboBoxText.new
		retrieveUser.each{|u| @comboBox.append_text(u)}

		@btn_login = Gtk::Button.new(:label => "Login")
		@btn_login.set_size_request 70, 30

		@btn_login.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new())
		end

		@vbox = Gtk::Box.new(:vertical, 2)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@btn_login, :expand => true, :fill => true, :padding =>2)

		#add(@btn_login)

	end

	def retrieveUser()
		path = "../Users"
		return Dir.entries(path).select { |f| f.match(/User\_(.*)/)}.select{|x| x.slice!(0,5)}
	end
end
