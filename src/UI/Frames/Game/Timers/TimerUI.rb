require_relative '../../../../Timer'

class TimerUI < Gtk::Label

	def initialize(map)
		super()
		@map = map
	end

	def markup(text)
		return text
	end

	def text
		raise NotImplementedError, "a " + self.class.name + " needs to know what to do when getting the text"
	end

	def refresh
		self.markup = self.markup(self.text)
	end

end
