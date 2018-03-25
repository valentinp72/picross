require_relative '../Window'
require_relative '../../User'

##
# File          :: AboutWindow.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/25/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
# This class represents an about window to show the user some informations about us, and this application.

class AboutWindow < Window

	# The name of the application
	APP_NAME = 'Ruþycross'

	# The authors
	AUTHORS  =
%Q[Baptiste Brinon
Thibault Brocherieux
Mehdi Cohen
Valentin Debonne
Anthony Lardy
Emeric Mottier
Gilles Pastouret
Valentin Pelloin
]
	
	# The version of the application
	VERSION  = '1.0'

	# The relase year of this version
	YEAR     = '2018'

	# The license of the appication
	LICENSE  = 'MIT License'

	##
	# Create an about window to show the user some informations
	# about the applicaiton.
	# * *Arguments* :
	#   - +applicaiton+ -> the application of this window
	def initialize(application)
		super(application)

		# we get the lang to display theses informations,
		# if no lang (not logged in), we choose the default language
		if application.connectedUser != nil then
			@lang = application.connectedUser.lang
		else
			@lang = User.defaultLang
		end
		@abt = @lang['about']
		@content = createContent
		
		self.set_size_request(200, 200)
		self.title = @abt['name']
		self.add(@content)
	end

	##
	# Create the layout of the content of this window
	# * *Returns* :
	#   - a Gtk::Grid containting everything, and and the answer
	#     to the meaning of life, the universe, and everything (42)
	def createContent
		content = Gtk::Grid.new

		content.row_spacing = 5
		content.halign = Gtk::Align::CENTER
		content.valign = Gtk::Align::CENTER
	
		contents = self.createContents
		contents.each_index do |index|
			content.attach(contents[index], 0, index, 1, 1)
		end
		
		return content # 42
	end

	##
	# Create all the GTK widgets to be displayed.
	# * *Returns* :
	#   - an Array containing all the widgets (mostly Gtk::Label)
	def createContents
		contents = []
		
		contents << createLabel("<b><big>#{APP_NAME}</big></b>")
		contents << createLabel(@abt['version'] + ' ' + VERSION + " (#{YEAR})")
		contents << createLabel(LICENSE)
		contents << createLabel("<b>#{@abt['authors']}</b>")
		contents << createLabel(AUTHORS)

		return contents
	end

	##
	# Create and return a Gtk::Label with the given content (markup).
	# It's then possible to use HTML/CSS-like classes.
	# * *Arguments* :
	#   - +content+ -> the markup content to be in the label
	# * *Returns* :
	#   - the Gtk::Label with the given content
	def createLabel(content)
		label = Gtk::Label.new
		label.set_markup(content)
		return label
	end

end
