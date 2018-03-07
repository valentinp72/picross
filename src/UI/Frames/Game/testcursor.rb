require "gtk3"

require_relative '../../AssetsLoader'

window = Gtk::Window.new("Gdk::Cursor sample")
window.signal_connect('destroy') {Gtk.main_quit}
window.realize

button = Gtk::Button.new(:label => "Click!")
button.use_underline = false

#cursor   = Gdk::Cursor.new(Gdk::CursorType::SHUTTLE)
#oldImage = cursor.image
#puts oldImage.inspect

#cursor = Gdk::Cursor.new(AssetsLoader.loadPixbuf('mouse.png'), 5, 5)
cursor = Gdk::Cursor.new("default")
window.window.set_cursor(cursor)

window.add(button)
window.set_default_size(400,500)
window.show_all

Gtk.main
