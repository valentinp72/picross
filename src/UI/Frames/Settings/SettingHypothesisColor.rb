
class SettingHypothesisColor < Setting

	def initialize(user, id)
		@user = user
		@id   = id

		@color = Gtk::ColorButton.new
		@color.color = Gdk::Color.parse(@user.settings.hypothesesColors[id])

		super(@user.lang["option"]["chooseHypColor"]["#{id}"], @color)
	end

	def save
		@user.settings.hypothesesColors[@id] = self.to_hex_color
	end

	def to_hex_color
		hex_by_12 = @color.color.to_s[1..-1]
		hex_by_6  = ""

		hex_by_12.scan(/.{4}/).each do |subcolor|
			hex_by_6 += subcolor[0..1]
		end
		return "#" + hex_by_6
	end

end
