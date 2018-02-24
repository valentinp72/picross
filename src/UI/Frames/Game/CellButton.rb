class CellButton < Gtk::EventBox

	BUTTON_LEFT_CLICK  = 1
	BUTTON_RIGHT_CLICK = 3

	attr_reader :cell
	attr_writer :cell

	def initialize(cell, drag, cells)
		super()
		@cell  = cell
		@drag  = drag
		@cells = cells

		@surface = Cairo::ImageSurface.new(:argb32, 20, 20)
		@widget  = Gtk::Image.new(:surface => @surface)

		css_provider = Gtk::CssProvider.new
		css_provider.load(data: "
			image {
				background-color: red;
				border: 1px solid white;
			}
			.activated {
				background-color: black;
			}
			.crossed {
				background-color: gray;
			}
			.white {
				background-color: white;
			}

			.hyp0 {
				border-color: black;
			}
			.hyp1 {
				border-color: red;
			}
			.hyp2 {
				border-color: green;
			}
			.hyp3 {
				border-color: yellow;
			}
			.hyp4 {
				border-color: blue;
			}
		")

		@widget.style_context.add_provider(
				css_provider,
				Gtk::StyleProvider::PRIORITY_USER
		)

		self.events |= (
			Gdk::EventMask::BUTTON_PRESS_MASK |
			Gdk::EventMask::BUTTON_RELEASE_MASK |
			Gdk::EventMask::ENTER_NOTIFY_MASK |
			Gdk::EventMask::LEAVE_NOTIFY_MASK)

		self.signal_connect('button_press_event') do |widget, event|

			# force to not grab focus on current button
			Gdk.pointer_ungrab(Gdk::CURRENT_TIME)

			if event.button == BUTTON_LEFT_CLICK then
				@drag.startLeftDrag(@cell)
			elsif event.button == BUTTON_RIGHT_CLICK then
				@drag.startRightDrag(@cell)
			end

			self.setCSSClass

		end

		self.signal_connect('button_release_event') do |widget, event|
			@drag.reset
		end

		self.signal_connect('enter_notify_event') do |widget, event|
			@drag.update(@cell)
			self.setCSSClass
		end

		self.signal_connect('leave_notify_event') do |widget, event|
		end

		self.setCSSClass()
		self.add(@widget)

	end

	def setCSSClass()
		wantedClasses = []

		# chooses the class about the state of the cell
		state = "white"
		case @cell.state
			when Cell::CELL_BLACK
				state = "activated"
			when Cell::CELL_CROSSED
				state = "crossed"
		end
		wantedClasses.push state

		# chooses the class about the hypothesis of the cell
		hypothesis = "hyp"
		if @cell.hypothesis.id >= 0 && @cell.hypothesis.id <= 4 then
			hypothesis += @cell.hypothesis.id.to_s
		else
			hypothesis += "0"
		end
		wantedClasses.push hypothesis

		@widget.style_context.classes.each do |className|
			@widget.style_context.remove_class(className)
		end
		wantedClasses.each do |className|
			@widget.style_context.add_class(className)
		end
	end

end
