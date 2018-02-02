#!/usr/bin/env ruby

require 'optparse'
require 'rmagick'

require_relative 'Map'
require_relative 'Grid' 
require_relative 'Hypothesis' 

## 
# File          :: PicrossRecognizer.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/01/2018
# Last update   :: 02/02/2018
# Version       :: 0.1
#
# This program is used to convert picross images from http://www.nonograms.org to
# a grid, that is inside a Map object.  
# When this program is used, the picross image in parameter is converted and save to
# a file with the same name but with a .map extension, that is a Map.  
#
#
# Usage: 
# 		./PicrossRecognizer.rb [options] <image file>  
# 		./PicrossRecognizer.rb -h # for all options

class PicrossRecognizer

	##
	# Main program, this class method will be executed when the
	# file PicrossRecognizer.rb is executed.
	# * *Returns* :
	#   - the converted Map
	def PicrossRecognizer.mainProgram()

		arguments    = PicrossRecognizer.getArgs()
		solutionGrid = PicrossRecognizer.recognize(arguments[:imageFile], arguments[:saveImage])

		map  = Map.new(arguments[:name], 
					   arguments[:time], 
					   arguments[:difficulty], 
					   solutionGrid.lines, 
					   solutionGrid.columns, 
					   solutionGrid)

		print map if arguments[:verbose]

		map.save(arguments[:output])
		return map
	end

	##
	# Get all the program arguments. The program exit if the program usage
	# is not correct.  
	# * *Returns* :
	#   - An Hash, containing arguments and options:
	#     - +:imageFile+  > image path
	#     - +:difficulty+ > difficulty given by the user (default 0)
	#     - +:name+       > wanted name of the map (default the name of the image file)
	#     - +:time+       > estimated time to resolve the map (default 0) 
	#     - +:output+     > output file for the map (default the name of the image.map)
	#     - +:saveImage+  > boolean, indicate if we should save the converted image (default false)
	#     - +:verbose+    > boolean, indicate if the should be in verbose mode (default false) 
	def PicrossRecognizer.getArgs()
		arguments = {}

		# default options values 
		arguments[:difficulty] = 0
		arguments[:name]       = "Unknown"
		arguments[:time]       = 0
		arguments[:saveImage]  = false
		arguments[:verbose]    = false

		parser = OptionParser.new do |opt|
			opt.banner += ' <image file>'
			opt.on('-o', '--output OUTPUT_FILE', 'Output map file')    { |o| arguments[:output]     = o }
			opt.on('-s', '--saveImage', 'Save the converted image?')   { |o| arguments[:saveImage]  = o }
			opt.on('-n', '--name MAP_NAME', 'The name of the map')     { |o| arguments[:name]       = o }
			opt.on('-t', '--time TIME_TO_DO', 'Time to resolve')       { |o| arguments[:time]       = o }
			opt.on('-d', '--difficulty DIFFICULTY', 'Game difficulty') { |o| arguments[:difficulty] = o }
			opt.on('-v', '--verbose', 'Verbose mode')                  { |o| arguments[:verbose]    = o }
		end
		parser.parse!

		if ARGV.length != 1 then
			puts parser.help, "\n"
			raise OptionParser::MissingArgument, ' <image file>'
		end
		arguments[:imageFile]  = ARGV.first
		
		if !arguments[:output] then
			arguments[:output] = PicrossRecognizer.getOutputFile(arguments[:imageFile]) 
		end

		return arguments 
	end

	##
	# Converts the file image name to a file map name
	# * *Arguments* :
	#   - +originalFile+ -> the path, name and extension of the file
	# * *Returns* :
	#   - the same file name, but with a +.map+ extension
	def PicrossRecognizer.getOutputFile(originalFile)
		# let's say originalFile = "/home/toto/image.png"

		dir  = File.dirname(originalFile)       # dir  = "/home/toto"
		ext  = File.extname(originalFile)       # ext  = ".png" 
		name = File.basename(originalFile, ext) # name = "image"

		# we want something like "/home/toto/image.map"
		return dir + "/" + name + ".map"
	end

	##
	# Recognize the image file to a Grid of cells
	# * *Arguments* :
	#   - +file+       -> the file name of the image
	#   - +shouldSave+ -> boolean, if True, save the tmp image
	# * *Returns* :
	#   - the Grid
	def PicrossRecognizer.recognize(file, shouldSave)
		image = PicrossRecognizerImage.new(file)

		image.removeBottomText!
		image.forceColors!
		image.removeNumbers!
		image.removeGrayLines!
		image.formalizeCellsSize!
		image.scaleImage!
		
		image.save() if shouldSave

		return image.to_grid
	end

end

## 
# File          :: PicrossRecognizer.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 02/01/2018
# Last update   :: 02/02/2018
# Version       :: 0.1
#
# This class represents an image in the process of converting it to a Map.
class PicrossRecognizerImage

	# +ext+   - The extension of the image
	# +dir+   - The path to the image
	# +file+  - The full path to the image
	# +name+  - The name of the image
	# +image+ - The Magick::Image image

	# List of valid extensions for image files
	VALID_EXTENSIONS = [".gif", ".png", ".jpeg", ".jpg"]

	# Color of pixels in black
	BLACK_COLOR = "black"
	# Color of pixels in white
	WHITE_COLOR = "white"

	# Height of the nonograms.org text in the images (in pixels)
	TEXT_HEIGHT = 10 
	# Size, in pixels of a standard cell
	CELL_SIZE   = 12

	##
	# Create a PicrossRecognizerImage, used for converting image to grid
	# * *Arguments* :
	#   - +file+ -> image file
	# * *Raises* :
	#   - +ArgumentError+ -> if the file does not exists, or if it isn't a valid image
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
		@image = Magick::ImageList.new(file)
	end

	##
	# Removes the bottom text of the image
	def removeBottomText!()
		@image.crop!(0, 0, @image.columns, @image.rows - TEXT_HEIGHT)
		return self
	end

	##
	# Forces the image to be constitued of excaclty 3 colors.  
	# The three colors are "white", "black" and a sort of gray, that is
	# used between cells.
	def forceColors!()
		# we force our image to be constitued of 3 colors excactly (white, black, and the gray between cells)
		@image = @image.trim.posterize(3).trim
		return self
	end

	##
	# Removes the solution numbrs (up and left of the image)
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

	##
	# Convert the pixel at given coordinates to a 'boolean' Float color number
	# * *Arguments* :
	#   - +column+ -> the column to take the pixel from
	#   - +row+    -> the row to take the pixel from
	# * *Returns* :
	#   - +0.0+ if the color is black
	#   - +1.0+ if the color is white
	#   - +nil+ otherwise
	def imagePixelToColor(column, row)
		# we get the pixel
		pixel_color = @image.get_pixels(column, row, 1, 1).first.to_color

		return 0.0 if pixel_color == BLACK_COLOR
		return 1.0 if pixel_color == WHITE_COLOR

		return nil
	end

	##
	# Removes the gray lines (vertical and horizontal) in the image
	def removeGrayLines!()
		pixels = []
		width  = 0
		height = 0

		0.upto(@image.rows - 1) do |row|
			currentWidth = 0

			0.upto(@image.columns - 1) do |column|
				color = imagePixelToColor(column, row)

				# we add only black and white pixels
				if color != nil then
					pixels.push(color)
					currentWidth += 1
					width = [width, currentWidth].max
				end
			end
			if currentWidth != 0 then
				height += 1
			end
		end
		@image = Magick::Image.constitute(width, height, "I", pixels)
		return self
	end

	##
	# Set all the cells to be exactly the same size (by default, 
	# the outer ones are not x12 but x11).  
	# This simply add a 1px white border around all the image
	def formalizeCellsSize!()
		# we add a border around the grid, because all the exteriors cells
		# are not 12*12, but 12*11 or 11*11
		@image.border!(1,1, "white")
	end

	##
	# Scales the image so that a cell is excactly 1px x 1px
	def scaleImage!()
		# we scale down the image so that a cell is 1px x 1px
		width  = (@image.columns / CELL_SIZE).floor
		height = (@image.rows    / CELL_SIZE).floor
		@image.scale!(width, height)
		@image = @image.posterize(2)
	end

	##
	# Saves the working temporary image to a _saved image
	def save()
		@image.write(@dir + "/" + @name + "_saved" + @ext)
	end

	##
	# Converts the image to a grid
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

# The beginning is the most important part of the work.
#  -- Plato

# Let's begin!
PicrossRecognizer.mainProgram

