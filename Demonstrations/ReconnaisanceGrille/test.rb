require 'rmagick'
include Magick

file = "images/small"
format = ".png"

text_height = 10

cat = ImageList.new(file + format)

n = cat
n.crop!(0, 0, n.columns, n.rows - text_height)
n = n.trim.quantize(3, GRAYColorspace)#.edge(100).trim

firstLine   = n.get_pixels(0, 0, n.columns, 1)
firstColumn = n.get_pixels(0, 0, 1, n.rows)

line = n.get_pixels(0, 33, n.columns, 1)
line.each do |p|
	puts p.to_s
	puts p.to_color
end

verticalLine   = firstLine.index   { |pixel| pixel.to_color == "#000B000B000B" }   + 4
horizontalLine = firstColumn.index { |pixel| pixel.to_color == "#000B000B000B" } + 4

puts verticalLine
puts horizontalLine

n.crop!(verticalLine, horizontalLine, n.columns, n.rows)

i = 0
n.get_pixels(1,1,n.columns - 1,1).each do |p|
#	puts p.to_s + "  " + i.to_s
#	puts p.to_color
	print p.red   / 257, " "
	print p.green / 257, " "
	print p.blue  / 257, "  " +  i.to_s + "\n"
	i += 1
end

print "(#{n.columns}, #{n.rows})\n"
factor = 12.0
width  = (n.columns / factor).floor
height = (n.rows / factor).floor

n.resize!(width, height)
print "(#{n.columns}, #{n.rows})\n"
n = n.quantize(2)
n.write(file + "_new" + format)

exit
