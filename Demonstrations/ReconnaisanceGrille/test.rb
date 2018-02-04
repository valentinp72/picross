require 'rmagick'
include Magick

#file = "images/very_big_huge"
file = "images/normal"
format = ".png"

TEXT_HEIGHT = 10 # in pixels
CELL_SIZE   = 12.0

# 16 bit hex colors:
BLACK_COLOR = "black" 
WHITE_COLOR = "white"

n = ImageList.new(file + format)

# we remove text
n.crop!(0, 0, n.columns, n.rows - TEXT_HEIGHT)

# we force our image to be constitued of 3 colors excactly (white, black, and the gray between cells)
n = n.trim.posterize(3).trim#quantize(4, GRAYColorspace, NoDitherMethod).trim
n.write(file + "j_" + format)
c = []
n.each_pixel do |p|
	if c.index(p.to_color) == nil then
		c.push(p.to_color)
	end
end
print c

# calculation of numbers size
firstLine   = n.get_pixels(0, 0, n.columns, 1)
firstColumn = n.get_pixels(0, 0, 1, n.rows)

verticalLine   = firstLine.index   { |pixel| pixel.to_color == BLACK_COLOR } + 4
horizontalLine = firstColumn.index { |pixel| pixel.to_color == BLACK_COLOR } + 4

# we remove the numbers
n.crop!(verticalLine, horizontalLine, n.columns, n.rows)



# remove gray pixels

pixels = []
width  = 0
height = 0

0.upto(n.rows - 1) do |row|
	currentWidth = 0
	0.upto(n.columns - 1) do |column|
		# we get the pixel
		pixel_color = n.get_pixels(column, row, 1, 1).first.to_color

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

noGrayImg = Image.constitute(width, height, "I", pixels)

# we add a border around the grid, because all the exteriors cells
# are not 12*12, but 12*11 or 11*11
noGrayImg.border!(1,1, "white")

# we scale down the image so that a cell is 1px x 1px
width  = (noGrayImg.columns / CELL_SIZE).floor
height = (noGrayImg.rows   / CELL_SIZE).floor
noGrayImg.scale!(width, height)
noGrayImg.write(file + "_new" + format)



noGrayImg.each_pixel do |pixel|
	if pixel.to_color == "black" then
		print "B"
	elsif pixel.to_color == "white" then
		print "W"
	else
		print "E"
	end
end

exit
