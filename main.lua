Actor = require("Actor")
require("Action")
require('Map')
require('Editor')

Player = Actor.new()
Player:loadCostume("img/Ayne_Moosader.png", 32, 48)
Player.x = 0; Player.y = 32

function love.load()
	JIFFY = 1/30
	brum = Actor.new()
	brum:loadCostume("brum.png", 200, 200)
	function brum:sleep()
		if Signal["left pressed"] then brum.x = brum.x - 8 end
		if Signal["right pressed"] then brum.x = brum.x + 8 end
		if Signal["up pressed"] then brum.y = brum.y - 8 end
		if Signal["down pressed"] then brum.y = brum.y + 8 end
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
	Editor.init()
	--Action:push(Player)
	if not Map.load("plains.lua") then
		print('Failed to load map')
		love.event.quit()
    	end
    
    Editor.init()
end

function love.update()
	start = love.timer.getMicroTime()
	Editor.update()
end

function love.mousepressed(x, y, button)
	Editor.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Editor.mousereleased(x, y, button)
end

function love.draw()
	love.graphics.setCaption("Baggage Reclaim Man - Gotta LOVE lime")
	Editor.draw()
	Action:update()
	Actor.draw()
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
	Signal = {}
end

