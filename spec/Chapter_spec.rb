require 'spec_helper'

describe Chapter do

	levels = Array.new(Map.new("Map 1",360,2,5,5,Grid.new(5,5)))
	levels.append(Map.new("Map 2",360,2,10,10,Grid.new(10,10)))

	chap = Chapter.new("Chapter 1",levels,100) 

	it "initialize chapter" do
		expect(chap.title).to eq "Chapter 1"
		expect(grid.levels).to eq levels
		expect(grid.starsRequired).to eq 100
		expect(grid.isUnlocked).to eq false
	end

	it "should display the chapter" do
		string = chap.to_s
  	expect(string[8]).to eq "Chapter : Chapter 1, levels : #{levels}, stars required : 100, unlocked? : false"
	end
