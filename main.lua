Actor = require("Actor")

function love.load()
	JIFFY = 1/30
	brum = Actor.new()
	brum:loadCostume("brum.png", 200, 200)
	function brum:sleep()
		self:jumpReel(0)
		if self.tick == 8 then 
			self:nextClip() 
		elseif self.tick == 4 then 
			self:prevClip()
		elseif self.tick < 0 then 
			self.tick = 12 
		end
	end
	brum.tick = 12
	brum.animate = brum.sleep

end

function love.update()
	start = love.timer.getMicroTime()
end

function love.draw()
	love.graphics.setCaption("Baggage Reclaim Man - Gotta LOVE lime")
	-- love.graphics.print('hello, world.', 400, 300
	brum:updateClip()
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
end

