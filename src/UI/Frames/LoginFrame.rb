require_relative '../Frame'
require_relative '../ButtonCreator'
require_relative '../GridCreator'
require_relative 'HomeFrame'
require_relative 'NewUserFrame'
require_relative '../../User'
require_relative '../../Picross'

##
# File          :: LoginFrame.rb
# Author        :: BROCHERIEUX Thibault, PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the LoginFrame which is the first page we encounter when we launch the application

class LoginFrame < Frame

	def initialize(language = 'francais')
		super()
		self.border_width = 100

		@currentLanguage = language
		@lang = User.loadLang(language)

		self.reset
	end

	def reset
		self.children.each do |child|
			self.remove(child)
		end
		@layout = self.createLayout
		self.add(@layout)
		self.show_all
	end

	def createLayout
		content = GridCreator.fromArray(self.createContent, :vertical   => true)
		footer  = GridCreator.fromArray(self.createFooter,  :horizontal => true)
		layout  = GridCreator.fromArray([content, footer])
		return layout
	end

	def createContent
		# Create a new comboBox which will hold all the username
		@userSelection = Gtk::ComboBoxText.new
		@userSelection.signal_connect "realize" do
			self.parent.picross.retrieveUser.each{ |u| @userSelection.append_text(u) }
			@userSelection.set_active(0)
		end

		# Add a button to create a new user
		@createBtn = ButtonCreator.main(
				:name    => @lang["login"]["new"],
				:clicked => :btn_newAccount_clicked,
				:parent  => self,
		)

		# Add a login button
		@loginBtn = ButtonCreator.main(
				:name    => @lang["login"]["login"],
				:clicked => :btn_login_clicked,
				:parent  => self,
		)

		return [@userSelection, @createBtn, @loginBtn]
	end

	def createFooter
		buttons   = []
		languages = User.languagesName

		languages.each do |language|
			next if language == @currentLanguage
			button = ButtonCreator.new(
				:assetName => "flag_#{language}.png",
				:assetSize => 20
			)
			button.signal_connect('clicked') { btn_changeLanguage(language) }
			buttons.push(button)
		end
		return buttons
	end

	def btn_newAccount_clicked
		self.parent.setFrame(NewUserFrame.new(@lang))
	end

	def btn_login_clicked
		# The button login works only if a user is selected.
		if @userSelection.active_text != nil then
			user = self.parent.picross.getSelectedUser(@userSelection.active_text)
			self.parent.application.connectedUser = user
			self.parent.setFrame(HomeFrame.new(user))
		end
	end

	def btn_changeLanguage(newLanguage)
		@lang = User.loadLang(newLanguage)
		@currentLanguage = newLanguage
		self.reset
	end

end
