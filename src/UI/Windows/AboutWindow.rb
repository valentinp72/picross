require_relative '../Window'
require_relative '../../User'

class AboutWindow < Window

	APP_NAME = 'Ruþycross'
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
	VERSION  = '1.0'
	YEAR     = '2018'
	LICENSE  = 'MIT License'

	def initialize(application)
		super(application)

		if application.connectedUser != nil then
			@lang = application.connectedUser.lang
		else
			@lang = User.defaultLang
		end
		@abt = @lang['about']

		self.title = @abt['name']
		@content = createContent
		self.add(@content)
	end

	def createContent
		content = Gtk::Grid.new

		content.row_spacing = 5
		content.halign = Gtk::Align::CENTER
		content.valign = Gtk::Align::CENTER
	
		contents = self.createContents
		contents.each_index do |index|
			content.attach(contents[index], 0, index, 1, 1)
		end
		
		return content
	end

	def createContents
		contents = []
		
		contents << createLabel("<b><big>#{APP_NAME}</big></b>")
		contents << createLabel(@abt['version'] + ' ' + VERSION + " (#{YEAR})")
		contents << createLabel(LICENSE)
		contents << createLabel("<b>#{@abt['authors']}</b>")
		contents << createLabel(AUTHORS)

		return contents
	end

	def createLabel(content)
		label = Gtk::Label.new
		label.set_markup(content)
		return label
	end

end
