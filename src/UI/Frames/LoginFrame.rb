require_relative '../Frame'
require_relative 'HomeFrame'
require_relative '../../User'

class LoginFrame < Frame

	def initialize()
		puts __FILE__
		super()
		self.border_width = 100
		@path = File.expand_path(File.dirname(__FILE__) + '/' + '../../Users')


		@comboBox = Gtk::ComboBoxText.new
		retrieveUser.each{|u| @comboBox.append_text(u)}

		@btn_login = Gtk::Button.new(:label => "Login")
		@btn_login.set_size_request 70, 30

		@btn_login.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(getSelectedUser))
		end

		@vbox = Gtk::Box.new(:vertical, 2)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@btn_login, :expand => true, :fill => true, :padding =>2)
		add(@vbox)

	end

	def getSelectedUser()
		puts "\n\n#{@path+'/User_'+@comboBox.active_text}\n\n"
		return User.load(@path + "/User_" + @comboBox.active_text)
	end

	def retrieveUser()
		return Dir.entries(@path).select { |f| f.match(/User\_(.*)/)}.select{|x| x.slice!(0,5)}
	end
end
