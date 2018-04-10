require_relative '../../GridCreator'
require_relative '../../ButtonCreator'

require_relative '../../../HelpMadeError'
require_relative '../../../HelpLvl1'
require_relative '../../../HelpLvl2'
require_relative '../../../HelpLvl3'

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

		contents << self.createTitle
		@helpers.each do |helper|
			contents << self.createHelperArea(helper)
		end

		return contents
	end

	def helpers
		helpers = []

		helpers << HelpMadeError.new(@frame.map, @frame.user)
		helpers << HelpLvl1.new(@frame.map, @frame.user)
		helpers << HelpLvl2.new(@frame.map, @frame.user)
		helpers << HelpLvl3.new(@frame.map, @frame.user)

		return helpers
	end

	def createTitle
		label = Gtk::Label.new
		title = @frame.user.lang['help']['available'].gsub('{{HELPS}}', @frame.user.availableHelps.to_s)
		label.markup = "<b><big>" + title + "</big></b>"
		return label
	end

	def createHelperArea(helper)
		lang     = @frame.user.lang
		helpInfo = lang['helps'][helper.class.name]

		title = Gtk::Label.new()
		title.markup = '<b>' + helpInfo['title'] + '</b>'

		description = Gtk::Label.new(helpInfo['description'])

		costP = createCostLabel('costPenalty', helper.class::COST_HELP)
		costH = createCostLabel('costHelp',    helper.class::COST_HELP/30)

		if @frame.user.availableHelps >= helper.class::HELP_COST then
			useHelp = lang['help']['costHelp'].gsub('{{COST}}', (helper.class::COST_HELP/30).to_s)
		else
			useHelp = lang['help']['costPenalty'].gsub('{{COST}}', helper.class::COST_HELP.to_s)
		end
		useButton = ButtonCreator.main(:name => lang['help']['use'].gsub('{{COST_NAME}}', useHelp))
		useButton.signal_connect('clicked') { self.btn_useHelp_clicked(helper,helper.class::COST_HELP) }

		helperContent = [title, description, costP, costH, useButton]
		return GridCreator.fromArray(helperContent, :vertical => true)
	end

	def createCostLabel(costName, value)
		cost = Gtk::Label.new
		lang = @frame.user.lang['help']
		name = lang['cost'] + lang[costName].gsub('{{COST}}', value.to_s)

		if costName == 'costHelp' && @frame.user.availableHelps < value  ||
			 costName == 'costPenalty' && @frame.user.availableHelps >= (value / 30)
			then
			before = '<span strikethrough="true">'
			after  = '</span>'
		end
		before ||= ''
		after  ||= ''

		cost.markup = before + name + after
		return cost
	end

	def btn_useHelp_clicked(help, value)
		help.apply(value)
		@frame.checkMap
		@frame.updateGrid
		self.hide
	end

end
