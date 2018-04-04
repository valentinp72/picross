require_relative '../../../Timer'
require_relative '../../../Penalty'

require_relative '../../Frame'
require_relative '../../GridCreator'

require_relative 'Timers/TimerReal'
require_relative 'Timers/TimerPenalty'
require_relative 'Timers/TimerRemaining'

class TimerFrame < Frame

	def initialize(map)
		super()

		realTimer    = TimerReal.new(map) 
		penaltyTimer = TimerPenalty.new(map)
		remainTimer  = TimerRemaining.new(map)
		@timers = [realTimer, penaltyTimer, remainTimer]

		self.add(GridCreator.fromArray(@timers, :vertical => true))
		self.refresh
	end

	def refresh()
		@timers.each do |timer|
			timer.refresh
		end
	end

end
