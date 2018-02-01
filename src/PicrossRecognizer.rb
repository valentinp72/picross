require 'rmagick'
require_relative 'Grid' 
require_relative 'Hypothesis' 

include Magick

## 
# File          :: PicrossRecognizer.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/01/2018
# Last update   :: 02/01/2018
# Version       :: 0.1
#

class PicrossRecognizer


	def PicrossRecognizer.recognize(file)
		image = PicrossRecognizerImage.new(file)

		image.removeBottomText!
		image.forceColors!
		image.removeNumbers!
		image.removeGrayLines!
		image.formalizeCellsSize!
		image.scaleImage!
		image.save()

		return image.to_grid
	end

end

class PicrossRecognizerImage

	# @ext
	# @dir
	# @file
	# @name
	# @image

	VALID_EXTENSIONS = [".gif", ".png", ".jpeg", ".jpg"]

	# color names:
	BLACK_COLOR = "black"
	WHITE_COLOR = "white"

	# sizes in pixels:
	TEXT_HEIGHT = 10 
	CELL_SIZE   = 12

	def initialize(file)
		if not File.file?(file) then
			raise ArgumentError, "file does not exist"
		end
		
		@ext = File.extname(file)
		if not VALID_EXTENSIONS.include?(@ext.downcase) then
			raise ArgumentError, "file is not a valid image (should be a #{VALID_EXTENSIONS})"
		end
		
		@dir   = File.dirname(file)
		@file  = file
		@name  = File.basename(file, @ext)
		@image = ImageList.new(file)
	end

	def removeBottomText!()
		@image.crop!(0, 0, @image.columns, @image.rows - TEXT_HEIGHT)
		return self
	end

	# we force our image to be constitued of 3 colors excactly (white, black, and the gray between cells)
	def forceColors!()
		@image = @image.trim.posterize(3).trim
		return self
	end

	def removeNumbers!()
		# calculation of numbers size
		firstLine   = @image.get_pixels(0, 0, @image.columns, 1)
		firstColumn = @image.get_pixels(0, 0, 1, @image.rows)

		verticalLine   = firstLine.index   { |pixel| pixel.to_color == BLACK_COLOR } + 4
		horizontalLine = firstColumn.index { |pixel| pixel.to_color == BLACK_COLOR } + 4

		# we remove the numbers
		@image.crop!(verticalLine, horizontalLine, @image.columns, @image.rows)
		return self
	end

	def removeGrayLines!()
		pixels = []
		width  = 0
		height = 0

		0.upto(@image.rows - 1) do |row|
			currentWidth = 0

			0.upto(@image.columns - 1) do |column|
				# we get the pixel
				pixel_color = @image.get_pixels(column, row, 1, 1).first.to_color

				# we add only black and white pixels
				if pixel_color == BLACK_COLOR or pixel_color == WHITE_COLOR then
					if pixel_color == BLACK_COLOR then
						color = 0.0
					else
						color = 1.0
					end

					pixels.push(color)
					currentWidth += 1
					width = [width, currentWidth].max
				end
			end
			if currentWidth != 0 then
				height += 1
			end
		end
		@image = Image.constitute(width, height, "I", pixels)
		return self
	end

	def formalizeCellsSize!()
		# we add a border around the grid, because all the exteriors cells
		# are not 12*12, but 12*11 or 11*11
		@image.border!(1,1, "white")
	end

	def scaleImage!()
		# we scale down the image so that a cell is 1px x 1px
		width  = (@image.columns / CELL_SIZE).floor
		height = (@image.rows    / CELL_SIZE).floor
		@image.scale!(width, height)
		@image = @image.posterize(2)
	end

	def save()
		@image.write(@dir + "/" + @name + "_saved" + @ext)
	end

	def to_grid()
		lines   = @image.rows
		columns = @image.columns
		grid = Grid.new(lines, columns, Hypothesis::SOLUTION_HYPOTHESIS)

		0.upto(lines - 1) do |line|
			0.upto(columns - 1) do |column|
				cell = grid.getCellPosition(line, column)
				if @image.get_pixels(column, line, 1, 1).first.to_color == BLACK_COLOR then
					cell.state = Cell::CELL_BLACK
				else
					cell.state = Cell::CELL_WHITE
				end
			end
		end

		return grid
	end

end

a = PicrossRecognizer.recognize("../Demonstrations/ReconnaisanceGrille/images/very_big_huge.png")

print a
