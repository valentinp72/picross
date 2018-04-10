class Setting

	attr_reader :label

	attr_reader :widget

	def initialize(text, widget)

		@label  = Gtk::Label.new(text)
		@widget = widget

		@label.halign  = Gtk::Align::START
		@widget.halign = Gtk::Align::END

	end

	def save
		raise NotImplementedError, "a Setting needs to know what to do when saving"
	end

end
