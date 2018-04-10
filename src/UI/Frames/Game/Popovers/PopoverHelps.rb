require_relative '../../../GridCreator'
require_relative '../../../ButtonCreator'

require_relative '../../../../HelpMadeError'
require_relative '../../../../HelpLvl1'
require_relative '../../../../HelpLvl2'
require_relative '../../../../HelpLvl3'

require_relative 'Popover'

##
# File          :: PopoverHelps.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 05/04/2018
# Last update   :: 10/04/2018
# Version       :: 0.1
#
# This class represents a Povover allowing the user to use Helps. 

class PopoverHelps < Popover

	##
	# Create a new popover for helps
	# * *Arguments* :
	#   - +button+ -> the button the popover is linked on
	#   - +frame+  -> the frame of the popover
	def initialize(button, frame)
		super(button)
		@frame   = frame
		@helpers = self.helpers
	end

	##
	# Return a Gtk::Grid with all the wigets of this popover
	# * *Returns* : 
	#   - a Gtk::Grid
	def content
		return GridCreator.fromArray(self.contents, :vertical => true)
	end

	##
	# Gets the content to be put inside the popver (an array)
	# * *Returns* :
	#   - an Array of Gtk::Widget
	def contents
		contents = []

		contents << self.createTitle
		@helpers.each do |helper|
			contents << self.createHelperArea(helper)
		end

		return contents
	end

	##
	# Returns the helps modules to be put inside the povover (an Array)
	# * *Returns* :
	#   - an Array of Help
	def helpers
		helpers = []

		helpers << HelpMadeError.new(@frame.map, @frame.user)
		helpers << HelpLvl1.new(@frame.map, @frame.user)
		helpers << HelpLvl2.new(@frame.map, @frame.user)
		helpers << HelpLvl3.new(@frame.map, @frame.user)

		return helpers
	end

	##
	# Create the title of the popover
	# * *Returns* : 
	#   - a Gtk::Label
	def createTitle
		label = Gtk::Label.new
		title = @frame.user.lang['help']['available'].gsub('{{HELPS}}', @frame.user.availableHelps.to_s)
		label.markup = "<b><big>" + title + "</big></b>"
		return label
	end

	##
	# Create the area (a Gtk::Grid) with all the content
	# of the helper inside
	# * *Arguments* :
	#   - +helper+ -> an Help
	# * *Returns* :
	#   - a Gtk::Grid
	def createHelperArea(helper)
		lang     = @frame.user.lang
		helpInfo = lang['helps'][helper.class.name]

		title = Gtk::Label.new()
		title.markup = '<b>' + helpInfo['title'] + '</b>'

		description = Gtk::Label.new(helpInfo['description'])

		costP = createCostLabel('costPenalty', helper)
		costH = createCostLabel('costHelp',    helper)

		if @frame.user.availableHelps >= helper.costHelps then
			useHelp = lang['help']['costHelp'].gsub('{{COST}}', (helper.costHelps).to_s)
		else
			useHelp = lang['help']['costPenalty'].gsub('{{COST}}', helper.costSeconds.to_s)
		end
		useButton = ButtonCreator.main(:name => lang['help']['use'].gsub('{{COST_NAME}}', useHelp))
		useButton.signal_connect('clicked') { self.btn_useHelp_clicked(helper) }

		helperContent = [title, description, costP, costH, useButton]
		return GridCreator.fromArray(helperContent, :vertical => true)
	end

	##
	# Create the Gtk::Label with the cost of the help
	# * *Arguments* :
	#   - +costName+ -> the name of the cost (in the language config file)
	#   - +helper+   -> the Help of the label
	# * *Returns* :
	#   - a Gtk::Label, with sometimes a strikethrough if it's not the appropriate help
	def createCostLabel(costName, helper)
		cost = Gtk::Label.new
		lang = @frame.user.lang['help']

		if costName == 'costHelp' then
			value = helper.costHelps
		elsif costName == 'costPenalty' then
			value = helper.costSeconds
		end

		if costName == 'costHelp' && @frame.user.availableHelps < helper.costSeconds  ||
			 costName == 'costPenalty' && @frame.user.availableHelps >= helper.costHelps
			then
			before = '<span strikethrough="true">'
			after  = '</span>'
		end
		before ||= ''
		after  ||= ''
		
		name = lang['cost'] + lang[costName].gsub('{{COST}}', value.to_s)

		cost.markup = before + name + after
		return cost
	end

	##
	# Action to be done when clicking on the help
	# * *Arguments* :
	#   - +help+ -> the Help
	# * *Returns* :
	#   - the object itself
	def btn_useHelp_clicked(help)
		help.apply
		@frame.updateGrid
		@frame.checkMap
		self.hide
		return self
	end

end
