Actor = require("Actor")

function love.load()
	JIFFY = 1/30
	tick = 30
	brum = Actor.new()
	brum:loadcostume("brum.png", 200, 200)
	brum:jumpreel(1)
end

function love.update()
	start = love.timer.getMicroTime()
end

function love.draw()
	love.graphics.setCaption("Baggage Reclaim Man - Gotta LOVE lime")
	-- love.graphics.print('hello, world.', 400, 300)
	love.graphics.drawq(brum.image, brum.quad, 100, 200)
	if tick == 15 then brum:nextclip() 
	elseif tick == 0 then brum:prevclip()
	elseif tick < 0 then tick = 30 end
	
	tick = tick - 1
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
end

