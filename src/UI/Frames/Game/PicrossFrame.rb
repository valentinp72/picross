require_relative 'CellButton'

require_relative '../../../Cell'
require_relative '../../../Drag'

class PicrossFrame < Frame

	def initialize(grid, columnSolution, lineSolution)
		super()
		self.border_width = 20
		@grid = grid
		@lineSolution = lineSolution
		@columnSolution = columnSolution

		createArea()
	end

	def createArea()
		@cells = Gtk::Grid.new
		@drag  = Drag.new(@grid, @cells)

		lineOffset = @lineSolution.map(&:length).max
		columnOffset = @columnSolution.map(&:length).max

		@drag.setOffsets(lineOffset, columnOffset)

		createNumbers(@cells, @columnSolution, lineOffset, columnOffset, false)
		createNumbers(@cells, @lineSolution, lineOffset, columnOffset, true)

		@grid.each_cell_with_index do |cell, line, column|
			@cells.attach(CellButton.new(cell, @drag, @cells), column + columnOffset, line + lineOffset, 1, 1)
		end

		add(@cells)
	end

	def createNumbers(cells,solution, lineOffset, columnOffset, isHorizontal)

		css_provider = Gtk::CssProvider.new
		css_provider.load(data: "
			.number {
				min-width : 20px;
				min-height: 20px;
				border    : 1px solid lightgray;
				color     : black;
			}
		")

		isHorizontal ? offset = lineOffset : offset = columnOffset
		i = 0
		solution.each do |n|
			j = 0
			n = n.reverse.fill(n.size..offset - 1){ nil }
			n.reverse.each do |m|
				label = Gtk::Label.new(m.to_s)
				label.style_context.add_class("number")
				label.style_context.add_provider(
						css_provider,
						Gtk::StyleProvider::PRIORITY_USER
				)
				if isHorizontal then
					cells.attach(label,j,i+lineOffset,1,1)
				else
					cells.attach(label,i+columnOffset,j,1,1)
				end
				j+= 1
			end
			i+= 1
		end
	end
end
