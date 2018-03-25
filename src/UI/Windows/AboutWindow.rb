require_relative '../Window'

class AboutWindow < Window

	def initialize(application)
		super(application)
		self.set_title "About"
		if application.connectedUser != nil then
			puts 'a'
		else
			puts 'b'
		end
	end

end
