require_relative 'TimerUI'

class TimerReal < TimerUI
	
	def text
		return '  ' + @map.currentStat.time.elapsedTime 
	end

end
