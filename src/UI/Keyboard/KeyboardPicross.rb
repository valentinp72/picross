class KeyboardPicross

	attr_accessor :posX
	attr_accessor :posY

	def initialize(picrossFrame, user, map)
		@frame = picrossFrame
		@user = user
		@map = map

		@posX = 0
		@posY = 0

		@enterDown = false
		@gaucheDown = false
		@hautDown = false
		@droiteDown = false
		@basDown = false
	end

	def updatePosition(posX, posY)
		@frame.leaveNotify(@posX,@posY)
		@posX += posX
		@posY += posY
		@frame.enterNotify(@posX,@posY)
	end

	def check(isPressed, posX, poxY)
		if event.type == Gdk::EventType::KEY_PRESS && !isPressed && @map.hypotheses.getWorkingHypothesis.grid.validPosition?(posX, posY) then
			return 1
		elsif  event.type == Gdk::EventType::KEY_RELEASE && isPressed then
			return 2
		end
		return 0
	end

	def click(event, click)
		if event.type == Gdk::EventType::KEY_PRESS && !@enterDown then
			@enterDown = true
			@frame.enterNotify(@posX,@posY)
			@frame.click(@posX,@posY,click)
		elsif event.type == Gdk::EventType::KEY_RELEASE && @enterDown then
			@enterDown = false
			@frame.unclick(@posX,@posY)
		end
	end

	def leftClick(event)
		# Left click
		self.click(event,CellButton::BUTTON_LEFT_CLICK)
	end

	def rightClick(event)
		# Right click
		self.click(event,CellButton::BUTTON_RIGHT_CLICK)
	end

	def moveLeft(event)
		# left touch
		testValue = check(@gaucheDown,@posX-1,@posY)
		case testValue
		when 1
			updatePosition(-1, 0)
			@gaucheDown = true
		when 2
			@gaucheDown = false
		end
	end

	def moveUp(event)
		# up touch
		testValue = check(@hautDown,@posX,@posY-1)
		case testValue
		when 1
			updatePosition(0, -1)
			@hautDown = true
		when 2
			@hautDown = false
		end
	end

	def moveRight(event)
		# right touch
		testValue = check(@droiteDown,@posX+1,@posY)
		case testValue
		when 1
			updatePosition(1, 0)
			@droiteDown = true
		when 2
			@droiteDown = false
		end
	end

	def moveDown(event)
		# down touch
		testValue = check(@basDown,@posX,@posY+1)
		case testValue
		when 1
			updatePosition(0, 1)
			@basDown = true
		when 2
			@basDown = false
		end
	end

	def on_key_press_event(event)
		case event.keyval
		when @user.settings.keyboardClickLeft
			leftClick(event)
		when @user.settings.keyboardClickRight
			rightClick(event)
		when @user.settings.keyboardLeft
			moveLeft(event)
		when @user.settings.keyboardUp
			moveUp(event)
		when @user.settings.keyboardRight
			moveRight(event)
		when @user.settings.keyboardDown
			moveDown(event)
		end
	end
end
