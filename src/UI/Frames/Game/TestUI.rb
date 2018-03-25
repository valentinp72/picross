
#!/usr/bin/env ruby
require 'gtk3'


class SolutionNumber < Gtk::Label

	def initialize(numberValue)
		super(numberValue.to_s)
		@value = numberValue
		
		css_provider = Gtk::CssProvider.new
		css_provider.load(data: self.css)
		@style_context = self.style_context
		@style_context.add_class("number")
		@style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
		self.set_size_request(15, 15)

		@toggle = false
	end

	def toggleHover()
		if @toggle == false then
			setHover
			@toggle = true
		else
			unsetHover
			@toggle = false
		end
	end

	def setHover()
		begin
			@style_context.add_class("hover")
		rescue Exception
			puts "GTK-gobject error(1): see https://github.com/valentinp72/picross/issues/31"
		end
		return self
	end

	def unsetHover()
		begin
			@style_context.remove_class("hover")
		rescue Exception
			puts "GTK-gobject error(2): see https://github.com/valentinp72/picross/issues/31"
		end
		return self
	end

	def css()
		"
			.number {
				color:  black;
				margin: 0px;
				padding-top:  1px;
				padding-left: 1px;
			}
			.hover {
				background-color: rgba(170, 20, 1, 0.2);
			}
		"
	end

end

class Grid < Gtk::Grid

	MAX_L = 20
	MAX_C = 20

	def initialize()
		super()

		0.upto(MAX_L) do |line|
			0.upto(MAX_C) do |column|
				value = line + column
				self.attach(SolutionNumber.new(value), column, line, 1, 1)
			end
		end

		# Update the timer view every second
		GLib::Timeout.add(10){
			l = rand(0..MAX_L - 1)
			c = rand(0..MAX_C - 1)
			cell = get_child_at(c, l)
			cell.toggleHover
			true
		}
	end

end

app = Gtk::Application.new("pw.vlntn.picross.rubycross", [:handles_open])

app.signal_connect('activate') do |application|
	window = Gtk::ApplicationWindow.new(application)
	window.add(Grid.new)
	window.present
	window.show_all
end

app.run([$0]+ARGV)
