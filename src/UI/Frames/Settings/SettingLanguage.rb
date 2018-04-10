class SettingLanguage < Setting

	def initialize(user)
		@user = user

		@selection = Gtk::ComboBoxText.new
		langs = self.retrieveLanguages
		langs.each do |l|
			@selection.append_text(l.gsub(/\w+/, &:capitalize))
		end
		# Set default value to the current use language
		@selection.set_active(langs.index(user.settings.language))

		super(@user.lang["option"]["chooseLanguage"], @selection)
	end

	def save
		if @selection.active_text != nil
			@user.settings.language = @selection.active_text.downcase
		end
		return self
	end

	##
	# This function retrieve all available languages
	def retrieveLanguages()
		path = File.dirname(__FILE__) + "/../../../Config/"
		return Dir.entries(path).select { |f| f.match(/lang\_(.*)/) }.select{ |x| x.slice!(0, 5) }
	end

end
