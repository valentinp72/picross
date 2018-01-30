require 'spec_helper'
require_relative '../src/Grid'
require_relative '../src/Map'
require_relative '../src/Chapter'

describe Chapter do
	
	grid1 = Grid.new(5,5,"soluce1")
	grid2 = Grid.new(10,10,"soluce2")
	
	grid1.randomCells
	grid2.randomCells

	levels = []
	levels.push(Map.new("Map 1",360,2,5,5,grid1))
	levels.push(Map.new("Map 2",360,2,10,10,grid2))
	chap = Chapter.new("Chapter 1",levels,100) 

	it "initialize chapter" do
		expect(chap.title).to eq "Chapter 1"
		expect(chap.levels).to eq levels
		expect(chap.starsRequired).to eq 100
		expect(chap.isUnlocked).to eq false
	end

	it "should display the chapter" do
		string = chap.to_s
  	expect(string).to eq "Chapter : Chapter 1, levels : #{levels}, stars required : 100, unlocked? : false"
	end

end
