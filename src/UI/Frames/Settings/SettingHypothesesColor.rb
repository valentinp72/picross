require_relative 'Setting'
require_relative 'SettingHypothesisColor'

class SettingHypothesesColor < Setting

	def initialize(user)
		@user = user

		@colors = Gtk::Grid.new()
		@colors.column_spacing = 5

		@colorsChoosers = [
			SettingHypothesisColor.new(user, 0),
			SettingHypothesisColor.new(user, 1),
			SettingHypothesisColor.new(user, 2),
			SettingHypothesisColor.new(user, 3),
			SettingHypothesisColor.new(user, 4)
		]

		line = 0
		@colorsChoosers.each do |colorChooser|
			@colors.attach(colorChooser.label,  0, line, 1, 1)
			@colors.attach(colorChooser.widget, 1, line, 1, 1)
			line += 1
		end

		super(@user.lang["option"]["chooseHypColors"], @colors)
	end

	def save
		@colorsChoosers.each do |colorChooser|
			colorChooser.save
		end
	end

end
