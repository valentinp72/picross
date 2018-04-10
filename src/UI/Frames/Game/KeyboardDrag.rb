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
	attr_writer :posX

	attr_reader :posY
	attr_writer :posY

	def initialize(picrossFrame)
		@picrossFrame = picrossFrame

		@posX = 0
		@posY = 0

		@keys = ["up", "down", "left", "right", "click-left", "click-right"]
		@picrossFrame.signal_connect('unrealize') do
			self.unsetKeys
		end
		
		self.setKeys
	end

	def setKeys
		keys = @picrossFrame.user.settings.picrossKeys
		@keys.each do |key|
			press   = "key_#{key.gsub('-', '_')}_pressed".to_sym
			release = "key_#{key.gsub('-', '_')}_released".to_sym
			@picrossFrame.toplevel.setKeyListener(
					keys[key],
					:pressMethod   => method(press), 
					:releaseMethod => method(release)
			)
		end
	end

	def unsetKeys
		keys = @picrossFrame.user.settings.picrossKeys
		@keys.each do |key|
			@picrossFrame.toplevel.unsetKeyListener(keys[key])
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
		end
		@picrossFrame.enterNotify(@posY, @posX)
	end

	def key_up_pressed
		self.moveDir(-1, 0)
	end

	def key_up_released

	end

	def key_down_pressed
		self.moveDir(1, 0)
	end

	def key_down_released

	end

	def key_left_pressed
		self.moveDir(0, -1)
	end

	def key_left_released

	end

	def key_right_pressed
		self.moveDir(0, 1)
	end

	def key_right_released

	end

	def key_click_left_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_LEFT_CLICK)
	end

	def key_click_left_released
		@picrossFrame.drag.reset
	end

	def key_click_right_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_RIGHT_CLICK)
	end

	def key_click_right_released
		@picrossFrame.drag.reset
	end

end
