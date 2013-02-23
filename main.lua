Actor = require("Actor")
require("Action")
require('Map')
require('Editor')

Player = Actor.new()
Player:loadCostume("img/Ayne_Moosader.png", 32, 48)
Player.x = 0; Player.y = 12
Player.grid = {x = 0, y = 0}

function Player:walk()
	if not self.tick or self.tick <= 0 then 
		self.tick = 4
	end 
	if self.tick == 4 or self.tick == 1 then self:nextClip()
	elseif self.tick == 2 or self.tick == 3 then self:prevClip() end
end

function Player:listen()
	self.vector = {}
	if Signal["left pressed"] then 
		self.vector.x = -8
		self:jumpReel(2)
		self.grid.x = self.grid.x - 1
	elseif Signal["right pressed"] then 
		self.vector.x = 8
		self:jumpReel(3)
		self.grid.x = self.grid.x + 1
	end

	if Signal["up pressed"] then 
		self.vector.y = -8
		self:jumpReel(1)
		self.grid.y = self.grid.y - 1
	elseif Signal["down pressed"] then 
		self.vector.y = 8 
		self:jumpReel(0)
		self.grid.y = self.grid.y + 1
	end

	print(Map.isSolid(1,self.grid.x, self.grid.y))

	local step = 4	-- lexical scoping, bitch ;) Essentially like a private variable for the walking
	if self.vector.x and self.vector.y then
		self.vector.x = self.vector.x / 2
		self.vector.y = self.vector.y / 2
		step = 8
	end

	if self.vector.x or self.vector.y then
		Player.animate = Player.walk
		Player.update = function (self)
			if self.vector.x then self.x = self.x + self.vector.x end
			if self.vector.y then self.y = self.y + self.vector.y end
			step = step - 1
			if step == 0 then Player.update = Player.listen end
		end
		Player:update()	-- call once so we don't get that dodgy skipping effect when the button is held down
	else
		self.tick = 0
		self.animate = nil
		self:jumpClip(1)
	end
		
end

Player.update = Player.listen



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
	Action:push(Player)
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

