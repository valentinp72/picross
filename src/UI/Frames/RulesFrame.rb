require 'yaml'

require_relative '../Frame'
require_relative 'HomeFrame'
require_relative '../ButtonCreator'

##
# File          :: RulesFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 04/04/2018
# Version       :: 0.1
#
# This class represents the RulesFrame which display rules

class RulesFrame < Frame

	##
	# Create a new Frame that show the rules.
	# * *Arguments* :
	#   - +user+ -> the user the frame is showing the maps of
	def initialize(user)
		super()
		self.border_width = 10
		@user    = user

		self.add(createPanel)
	end

	def createPanel
		@content = Gtk::Box.new(:vertical)
		@content.pack_start(createReturnBtn, :expand => false, :fill => false, :padding =>2)
		@content.pack_start(createRules, :expand => true, :fill => true, :padding =>2)
	end

	def createRules
		@scrolled = Gtk::ScrolledWindow.new
		@scrolled.set_policy(:never, :automatic)

		@listbox = Gtk::ListBox.new
		@scrolled.add(@listbox)

		@line =  Gtk::Label.new
		@user.lang["rules"].each do |str|
			@line.text += "\n" + str[1]
		end
		@line.wrap=true
		@listbox.add(@line)
		@listbox.show_all
		return @scrolled
	end

	##
	# Create the return button for this map
	# * *Returns* :
	#   - a Gtk::Button
	def createReturnBtn
		return ButtonCreator.new(
			:assetName => "arrow-left.png",
			:assetSize => 40,
			:clicked   => :btn_return_clicked,
			:parent    => self
		)
	end

	##
	# The action to be done when clicking on the return button
	# * *Returns* :
	#   - the frame itself
	def btn_return_clicked
		self.parent.setFrame(HomeFrame.new(@user))
		return self
	end

end
