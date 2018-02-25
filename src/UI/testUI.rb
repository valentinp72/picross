#!/usr/bin/env ruby
require 'gtk3'

Gtk.init

win = Gtk::Window.new('window')

<<<<<<< HEAD
win.set_default_size(4000, 4000)
=======
win.set_default_size(400, 400)
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab

frame = Gtk::Frame.new('frame')
frame.border_width = 10

draw = Gtk::DrawingArea.new()

<<<<<<< HEAD
draw.signal_connect "draw" do |widget, cr|
	w = widget.allocated_width
	h = widget.allocated_height
	cr.set_source_rgb(0.0, 1.0, 0)
	cr.paint
	cr.set_source_rgb(1.0, 0, 0)
	cr.arc(w/2, h/2, w/2, 0, 2 * Math::PI)
	cr.fill
	cr.destroy
#cr = draw.window.create_cairo_context

#	cr.set_source_rgb 1.0, 0.0, 0.0
#	cr.rectangle(10, 10, 100, 100)
#	cr.fill
	
end
draw.show

frame.reallocate_redraws = true
frame.add(draw)
win.add(frame)
#win.set_opacity(1.1)
win.set_decorated(false)
win.set_opacity(0)
win.show_all
win.resize(400, 400)	
win.set_app_paintable(false)


win.signal_connect('check-resize') do
=======
draw.signal_connect "draw" do
cr = draw.window.create_cairo_context

cr.set_source_rgb 1.0, 0.0, 0.0
cr.rectangle(10, 10, 100, 100)
cr.fill
	true
end
draw.show

frame.add(draw)
win.add(frame)
win.show_all

win.signal_connect('size-allocate') do

>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
end

Gtk.main
