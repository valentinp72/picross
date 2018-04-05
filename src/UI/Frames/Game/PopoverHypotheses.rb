require_relative '../../GridCreator'
require_relative '../../ButtonCreator'

require_relative 'Popover'

class PopoverHypotheses < Popover

	def initialize(button, frame)
		super(button)
		@frame = frame
	end

	def content
		return GridCreator.fromArray(self.contents, :horizontal => true)
	end

	def contents
		contents = []
		
		@frame.map.hypotheses.each do |hypothesis|
			contents << self.createHypothesisButtons(hypothesis)
		end
		if not @frame.map.hypotheses.max? then
			contents << self.createNewHypothesisButton
		end

		return contents
	end

	def createNewHypothesisButton()
		return ButtonCreator.new(
			:assetName => 'plus.png', 
			:assetSize => 40, 
			:parent    => self,
			:clicked   => :btn_new_clicked
		)
	end

	def createHypothesisButtons(hypothesis)
		css    = self.btnCSS(hypothesis)
		accept = ButtonCreator.new(:assetName => 'check.png', :assetSize => 40, :css => css)
		reject = ButtonCreator.new(:assetName => 'close.png', :assetSize => 40, :css => css)

		accept.signal_connect('clicked') { self.btn_accept_clicked(hypothesis) }
		reject.signal_connect('clicked') { self.btn_reject_clicked(hypothesis) }

		return GridCreator.fromArray([accept, reject], :vertical => true)
	end

	def btnCSS(hypothesis)
		"
			button {
				background-image: image(#{@frame.user.settings.hypothesesColors[hypothesis.id]});
			}
		"
	end

	def refresh
		@frame.updateGrid
		self.update
	end

	def btn_new_clicked()
		if not @frame.map.hypotheses.max?
			@frame.map.hypotheses.addNewHypothesis
			self.refresh
		end
	end

	def btn_accept_clicked(hypothesis)
		@frame.map.hypotheses.validate(hypothesis.id)
		self.refresh
	end

	def btn_reject_clicked(hypothesis)
		@frame.map.hypotheses.reject(hypothesis.id)
		self.refresh
	end

end
