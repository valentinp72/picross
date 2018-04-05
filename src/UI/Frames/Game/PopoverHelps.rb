require_relative '../../GridCreator'
require_relative '../../ButtonCreator'

require_relative '../../../HelpMadeError'

require_relative 'Popover'

class PopoverHelps < Popover

	def initialize(button, frame)
		super(button)
		@frame   = frame
		@helpers = self.helpers
	end

	def content
		return GridCreator.fromArray(self.contents, :vertical => true)
	end

	def contents
		contents = []

		@helpers.each do |helper|
			contents << self.createHelperArea(helper)
		end

		return contents
	end

	def helpers
		helpers = []

		helpers << HelpMadeError.new(@frame.map, @frame.user)

		return helpers
	end

	def createHelperArea(helper)
		return Gtk::Label.new(helper.to_s)
	end

end

