#!/usr/bin/env ruby
require 'gtk3'

Gtk.init

win = Gtk::Window.new('window')

win.set_default_size(400, 400)

frame = Gtk::Frame.new('frame')
frame.border_width = 10

draw = Gtk::DrawingArea.new()

draw.signal_connect "draw" do
	cr = draw.window.create_cairo_context

	cr.set_source_rgb 1.0, 0.0, 0.0
	cr.rectangle(10, 10, 100, 100)
	cr.fill
	
end
draw.show

frame.add(draw)
win.add(frame)
win.show_all

win.signal_connect('size-allocate') do

end

Gtk.main
