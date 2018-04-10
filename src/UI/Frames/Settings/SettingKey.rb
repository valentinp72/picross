require_relative 'Setting'

class SettingKey < Setting

	KEY_ESCAPE = 65307 

	def initialize(parent, user, name, keys)
		@user    = user
		@value   = keys[name]
		@key     = Gtk::Button.new(:label => Gdk::Keyval.to_name(@value))
		@parent  = parent
		@allKeys = keys
		@name    = name

		@key.signal_connect("clicked") do
			self.bindKey()
		end

		super(@user.lang["option"]["keyboard"][@name], @key)
	end

	def bindKey()
		message = @user.lang["option"]["bind"]
		@dialog = Gtk::MessageDialog.new(
				:parent       => @parent.parent,
				:flags        => :destroy_with_parent,
				:type         => :error,
				:buttons_type => :close,
				:message      => message
		)
		@dialog.secondary_text = @user.lang["option"]["bindCancel"]

		@dialog.signal_connect("key-press-event") do |w, e|
			self.on_key_press_event(e)
		end

		@dialog.signal_connect "response" do |dialog, _response_id|
			dialog.destroy
		end

		@dialog.show_all
	end

	def on_key_press_event(event)
		# if escape is pressed
		if event.keyval != KEY_ESCAPE then
			if event.type == Gdk::EventType::KEY_PRESS && !@keyPressed then
				@keyPressed = true
				if !@allKeys.has_value?(event.keyval) then
					@value = event.keyval
					@dialog.destroy
					@key.label = Gdk::Keyval.to_name(@value)
				end
				@keyPressed = false
			end
		end
	end

	def save
		@user.settings.changeKeyBoardValue(@value, @name)
	end

end
