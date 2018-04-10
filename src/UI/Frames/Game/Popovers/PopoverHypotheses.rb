require_relative '../../../GridCreator'
require_relative '../../../ButtonCreator'

require_relative 'Popover'

##
# File          :: PopoverHypotheses.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 05/04/2018
# Last update   :: 10/04/2018
# Version       :: 0.1
#
# This class represents a Povover allowing the user to use Hypotheses. 

class PopoverHypotheses < Popover

	##
	# Create a new popover for hypotheses
	# * *Arguments* :
	#   - +button+ -> the button the popover is linked on
	#   - +frame+  -> the frame of the popover
	def initialize(button, frame)
		super(button)
		@frame = frame
	end

	##
	# Return a Gtk::Grid with all the wigets of this popover
	# * *Returns* : 
	#   - a Gtk::Grid
	def content
		return GridCreator.fromArray(self.contents, :horizontal => true)
	end

	##
	# Gets the content to be put inside the popver (an array)
	# * *Returns* :
	#   - an Array of Gtk::Widget
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

	##
	# Create an return a Gtk::Button allowing creation of a new Hypothesis
	# * *Returns* :
	#   - a new Gtk::Button
	def createNewHypothesisButton()
		return ButtonCreator.new(
			:assetName => 'plus.png', 
			:assetSize => 40, 
			:parent    => self,
			:clicked   => :btn_new_clicked
		)
	end

	##
	# Create and return a Gtk::Grid containing everything for an 
	# hypothesis (validate and reject buttons).
	# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis to create the grid for
	# * *Returns* : 
	#   - a Gtk::Grid with buttons
	def createHypothesisButtons(hypothesis)
		css    = self.btnCSS(hypothesis)
		accept = ButtonCreator.new(:assetName => 'check.png', :assetSize => 40, :css => css)
		reject = ButtonCreator.new(:assetName => 'close.png', :assetSize => 40, :css => css)

		accept.signal_connect('clicked') { self.btn_accept_clicked(hypothesis) }
		reject.signal_connect('clicked') { self.btn_reject_clicked(hypothesis) }

		return GridCreator.fromArray([accept, reject], :vertical => true)
	end

	##
	# Returns the CSS for a button about an hypothesis
		# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis of wanted css
	# * *Returns* :
	#   - a String with CSS inside
	def btnCSS(hypothesis)
		"
			button {
				background-image: image(#{@frame.user.settings.hypothesesColors[hypothesis.id]});
			}
		"
	end

	##
	# Refresh the content of the popover
	# * *Returns* :
	#   - the object itself
	def refresh
		@frame.updateGrid
		self.update
		return self
	end

	##
	# Action to do when the new hypothesis button is clicked
	# * *Returns* :
	#   - the object itself
	def btn_new_clicked()
		if not @frame.map.hypotheses.max?
			@frame.map.hypotheses.addNewHypothesis
			self.refresh
		end
		return self
	end

	##
	# Action to do when the accecpt button of an hypothesis is clicked
	# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis the button is about
	# * *Returns* :
	#   - the object itself
	def btn_accept_clicked(hypothesis)
		@frame.map.hypotheses.validate(hypothesis.id)
		self.refresh
		return self
	end

	##
	# Action to do when the reject button a of an hypothesis is clicked
	# * *Arguments* :
	#   - +hypothesis+ -> the hypothesis the button is about
	# * *Returns* :
	#   - the object itself
	def btn_reject_clicked(hypothesis)
		@frame.map.hypotheses.reject(hypothesis.id)
		self.refresh
		return self
	end

end
