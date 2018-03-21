require 'spec_helper'

require_relative '../src/Grid'
require_relative '../src/Map'
require_relative '../src/Chapter'
require_relative '../src/User'

describe Chapter do
	
	grid1 = Grid.new(5,5,"soluce1")
	grid2 = Grid.new(10,10,"soluce2")
	
	grid1.randomCells
	grid2.randomCells

	levels = []
	levels.push(Map.new("Map 1",360,2,5,5,grid1))
	levels.push(Map.new("Map 2",360,2,10,10,grid2))
	chap1 = Chapter.new("Chapter 1", levels, 0) 
	chap2 = Chapter.new("Chapter 2", levels, 100) 

	user = User.new("testuser", [chap1, chap2])

	it "tests the title" do
		expect(chap1.title).to eq "Chapter 1"
		expect(chap2.title).to eq "Chapter 2"
	end

	it "tests the levels are good" do
		expect(chap1.levels).to eq levels
		expect(chap2.levels).to eq levels
	end

	it "tests the required stars" do
		expect(chap1.starsRequired).to eq 0
		expect(chap2.starsRequired).to eq 100
	end

	it "tests the chapters are locked an unlocked" do
		expect(chap1.unlocked?(user)).to eq true
		expect(chap2.unlocked?(user)).to eq false
	end

	it "tests the display of the chapters" do
  		expect(chap1.to_s).to eq "Chapter : Chapter 1, levels : #{levels}, stars required : 0"
  		expect(chap2.to_s).to eq "Chapter : Chapter 2, levels : #{levels}, stars required : 100"
	end

end
