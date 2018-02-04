#!/usr/bin/env ruby

require "open-uri"
require "nokogiri"

## 
# File          :: RetrievePicrossWeb.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/05/2018
# Last update   :: 02/05/2018
# Version       :: 0.1
#
# This program is used to retrieve information about a specific nonogram from http://www.nonograms.org
# This program can return the answer as a .png file
# It also return the size, title and difficulty
#
# Usage: 
# 		./RetrievePicrossWeb.rb <nonogram link>  

input_array = ARGV

if input_array.length != 1 then
		raise "Usage ' <nonogram link>'"
end

url = input_array[0]
html = open(url)
doc = Nokogiri::HTML(html)

#Retrieve answer's link
answer = doc.at_css("a#nonogram_answer")['href'] 
#Retrieve title of the nonogram
title = doc.at_css("a#nonogram_answer")['title'] 

#Retrieve table containing information about the nonogram
# - line
# - column
# - picture (useless?)
# - difficulty
table = doc.at_css("div.content").at_css("table")
detail = []

table.search('td').each do |td|
	detail << td
end

#title

title=/«([^»]*)»/.match(title.to_s)
fn = title[1].split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
title = fn.join '.'
title.downcase!
puts title

# COLUMN LINE
temp = /([0-9]*)x([0-9]*)/.match(detail.shift)

line = temp[1]
column = temp[2]


temp = /title="([0-9]*)\/10"/.match(detail.shift.to_s)
picture = temp[1]
temp = /title="([0-9]*)\/10"/.match(detail.shift.to_s)
difficulty = temp[1]

puts line, column, picture, difficulty

File.open('#{title[1]}.png', 'wb') do |fo|
  fo.write open(answer).read 
end

#exec("./PicrossRecognizer.rb --difficulty #{difficulty} answer.png")
