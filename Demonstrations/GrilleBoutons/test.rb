require "gtk3"

win = Gtk::Window.new
#frame = Gtk::Frame.new('test')
#win.add frame
# On definit une box horizontal
table = Gtk::Table.new(4,4)

# On definit un label
Label = Gtk::Label.new("Ceci est un test")
# On definit une entree
QuitBtn = Gtk::Button.new(:label => "Quitter")

listButton = Array.new(900){Hash.new()}
pressed = false


vbox = Gtk::Box.new(:vertical, 3)

# On definit une entree
0.upto(899) do |x|
	listButton[x]['bouton'] = Gtk::Button.new(:label => "#{x}")
	listButton[x]['color'] = 0
	listButton[x]['bouton'].override_background_color(0, Gdk::RGBA::new(0,1.0,0,1.0))
	listButton[x]['bouton'].set_events(Gdk::EventMask::BUTTON_PRESS_MASK)

	listButton[x]['bouton'].signal_connect('enter'){
		puts pressed
		if(pressed) then
			if(listButton[x]['color'] == 1) then
				listButton[x]['color'] = 0
				listButton[x]['bouton'].override_background_color(0, Gdk::RGBA::new(0,1.0,0,1.0))
			else
				listButton[x]['color'] = 1
				listButton[x]['bouton'].override_background_color(0, Gdk::RGBA::new(1.0,0,0,1.0))
			end
		end
	}

	listButton[x]['bouton'].signal_connect('button-press-event'){
		pressed = true
		puts "APPUIE"
	}

	listButton[x]['bouton'].signal_connect('button-release-event'){
		pressed = false
		puts "RELACHE"
	}

	table.attach(listButton[x]['bouton'], x%30, x%30+1, (x/30).to_i, (x/30).to_i + 1)
end

# 	win.signal_connect('button-press-event'){
# 	pressed = true
# 	puts "APPUIE"
# }
#
# 	win.signal_connect('button-release-event'){
# 	pressed = false
# 	puts "RELACHE"
# }
# win.set_events(Gdk::EventMask::BUTTON_PRESS_MASK)
# win.signal_connect('button-press-event'){
# pressed = true
# puts "APPUIE"
# }
#
# win.signal_connect('button-release-event'){
# pressed = false
# puts "RELACHE"
# }


# On ajoute la premier et deuxieme ligne a la fenetre (via la box principal)

vbox.pack_start(Label, :expand => true, :fill => true, :padding =>2)
vbox.pack_start(table, :expand => true, :fill => true, :padding =>2)
vbox.pack_start(QuitBtn, :expand => true, :fill => true, :padding =>2)

win.add(vbox)

win.signal_connect("destroy"){Gtk.main_quit}
win.show_all
Gtk.main
