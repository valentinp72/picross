class Popover < Gtk::Popover
	
	def initialize(button)
		super(button)
		
		self.position = :top
	end

	def content
		raise NotImplementedError, "a Popover needs to know what to do when getting it's content"
	end

	def setContent()
		self.children.each do |child|
			self.remove(child)
		end
		toAdd = self.content
		toAdd.show_all
		self.add(toAdd)
	end

	def update
		self.setContent
	end

end
