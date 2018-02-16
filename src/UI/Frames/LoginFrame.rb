require_relative '../Frame'
require_relative 'HomeFrame'
require_relative 'NewUserFrame'
require_relative '../../User'

class LoginFrame < Frame

	def initialize()
		super()
		self.border_width = 100
		@path = File.expand_path(File.dirname(__FILE__) + '/' + '../../../Users')


		@comboBox = Gtk::ComboBoxText.new
		retrieveUser.each{|u| @comboBox.append_text(u)}

		@loginBtn = Gtk::Button.new(:label => "Login")

		@createBtn = Gtk::Button.new(:label => "Create new account")

		@vbox = Gtk::Box.new(:vertical, 3)
		@vbox.pack_start(@comboBox, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@loginBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@createBtn, :expand => true, :fill => true, :padding =>2)

		@loginBtn.signal_connect("clicked") do
			if(@comboBox.active_text != nil) then
			user = getSelectedUser
			self.parent.setFrame(HomeFrame.new(user))
			end
		end

		@createBtn.signal_connect("clicked") do
			self.parent.setFrame(NewUserFrame.new())
		end

		add(@vbox)

	end

	def getSelectedUser()
		return User.load(@path + "/User_" + @comboBox.active_text)
	end

	def retrieveUser()
		return Dir.entries(@path).select { |f| f.match(/User\_(.*)/)}.select{|x| x.slice!(0,5)}
	end
end
