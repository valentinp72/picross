require_relative '../Window'
require_relative '../../User'

class AboutWindow < Window

	def initialize(application)
		super(application)
		self.set_title "About"

		if application.connectedUser != nil then
			lang = application.connectedUser.lang
		else
			lang = User.defaultLang
		end
	end

end
