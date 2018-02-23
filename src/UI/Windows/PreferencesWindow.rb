require_relative '../Window'

class PreferencesWindow < Window

	def initialize(application)
		super(application)
		self.set_title "Preferences"
		if application.connectedUser != nil then
			self.setFrame OptionFrame.new(application.connectedUser)
		else
			self.close
		end
	end

end
