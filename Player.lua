Player = Actor.new()
Player:loadCostume("img/Ayne_Moosader.png", 32, 48)
Player.x = 0; Player.y = -12
Player.grid = {x = 1, y = 1}

function Player:walk()
	if not self.tick or self.tick <= 0 then 
		self.tick = 8
	end 
	if self.tick == 8 or self.tick == 2 then self:nextClip()
	elseif self.tick == 4 or self.tick == 6 then self:prevClip() end
end

local function stopPlayer(self)
	self.tick = 0					-- when we're still, kill the action
	self.animate = nil
	self:jumpClip(1)
end

local function absoluteOffset(x, y)			-- why won't this work?
	local t = Map.tileInfo(1, x, y)
	return t.quad:getViewport()
end

local function  movePlayer(self, x, y)
	self.grid.x = x; self.grid.y = y
	local step = 4					-- lexical scoping, bitch ;) Essentially like a private variable for the walking
	if self.vector.x and self.vector.y then
		self.vector.x = self.vector.x / 2	-- half the vector speed for diagonal movement
		self.vector.y = self.vector.y / 2
		step = 8
	end

	if self.vector.x or self.vector.y then
		print(x.." "..y)
		self.animate = self.walk
		self.update = function (self)
			if self.vector.x then self.x = self.x + self.vector.x end
			if self.vector.y then self.y = self.y + self.vector.y end
			step = step - 1
			if step == 0 then
				self.update = self.listen 
			end
		end
		self:update()				-- call once so we don't get that dodgy skipping effect when the button is held down
		return
	end
	stopPlayer(self)
end

function Player:listen()
	self.vector = {}
	local x = self.grid.x 
	local y = self.grid.y
	if Signal["left pressed"] then			-- depending on the signal received we change the reel and the vector 
		self.vector.x = -8
		self:jumpReel(2)
		x = x - 1
	elseif Signal["right pressed"] then 
		self.vector.x = 8
		self:jumpReel(3)
		x = x + 1
	elseif Signal["up pressed"] then 
		self.vector.y = -8
		self:jumpReel(1)
		y = y - 1
	elseif Signal["down pressed"] then 
		self.vector.y = 8 
		self:jumpReel(0)
		y = y + 1
	end

	if x <= 0 or y <= 0 or x > Map.map.width or y > Map.map.height or Map.isSolid(1, x, y) then stopPlayer(self)
	else movePlayer(self, x, y) end


end

Player.update = Player.listen
