##
# File          :: PicrossFrame.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/07/2018
# Last update   :: 04/07/2018
# Version       :: 0.1
#

class KeyboardDrag 

	attr_reader :posX
	attr_reader :posY

	def initialize(picrossFrame)
		@picrossFrame = picrossFrame

		@posX = 0
		@posY = 0
		self.setKeys
	end

	def setKeys
		keys      = @picrossFrame.user.settings.picrossKeys
		keysToAdd = ["up", "down", "left", "right", "click-left", "click-right"]

		keysToAdd.each do |key|
			name = "key_#{key.gsub('-', '_')}_pressed".to_sym
			@picrossFrame.toplevel.setKeyListener(keys[key], method(name))
		end
	end

	def grid
		return @picrossFrame.grid
	end

	def moveDir(yDir, xDir)
		if self.grid.validPosition?(@posY + yDir, @posX + xDir) then
			@picrossFrame.leaveNotify(@posY, @posX)
			@posY += yDir
			@posX += xDir
			@picrossFrame.enterNotify(@posY, @posX)
		end
	end

	def key_up_pressed
		self.moveDir(-1, 0)
	end

	def key_down_pressed
		self.moveDir(1, 0)
	end

	def key_left_pressed
		self.moveDir(0, -1)
	end

	def key_right_pressed
		self.moveDir(0, 1)
	end

	def key_click_left_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_LEFT_CLICK)
	end

	def key_click_right_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_RIGHT_CLICK)
	end

end
