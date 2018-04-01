require 'spec_helper'

describe User do

	path = File.expand_path(File.dirname(__FILE__) + '/' + '../Users')
	chapters = Array.new()

	# Retrieve all default chapters
	chapterFolder = File.expand_path(path + '/' + "Default/chapters/")
	puts chapterFolder

	chapterFile = Dir.entries(chapterFolder).select { |f| f.match(/(.*).chp/)}

	chapterFile.each do |f|
		chapters.push(Chapter.load(chapterFolder + "/"+ f))
	end

	user = User.new("test",chapters)

	it "check all available language" do
		expect(User.languagesName).to eq ['english', 'francais']
	end

	# it "change to default language" do
	# 	expect(User.defaultLang()).to eq '{"login"=>{"login"=>"Login", "new"=>"Create new account"}, "newUser"=>{"username"=>"Enter username:",...me"=>"Total time", "help"=>"Total used help", "click"=>"Total click", "finished"=>"Finished game"}}}'
	# end

	it "check totalStars" do
		expect(user.totalStars).to eq 0
	end

	it "add 1 help to user" do
		expect(user.addHelp(1)).to eq 1
	end

	it "remove 1 help to user" do
		expect(user.removeHelp(1)).to eq 0
	end

	it "remove 100 help to user(impossible if doesn't have them)" do
		expect{user.removeHelp(100)}.to raise_error(User::NegativeAmountException)
	end

	it "add -10 help to user(impossible to add negative)" do
		expect{user.addHelp(-10)}.to raise_error(User::NegativeAmountException)
	end
end
