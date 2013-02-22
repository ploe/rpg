--[[ An Actor is the basic Sprite type ]]

local Actor_prototype = {
	x = 0, y = 0, h = 0, w = 0,		-- offset dimensions
	costume,				-- image, spritesheet
						-- quad dimenstions
	scale = 1,
	aura,
	tick = 0				-- bounding box
}

local mt = {}
mt.__index = Actor_prototype

function Actor_prototype:loadCostume(filename, w, h, scale)
	self.costume = love.graphics.newImage(filename)
	if not self.costume then
		print("Image not found, failed")
		return
	end
	self.clip.w = w; self.clip.h = h
	self.quad = love.graphics.newQuad (
		self.clip.x,
		self.clip.y,
		self.clip.w, 
		self.clip.h, 
		self.costume:getWidth(),
		self.costume:getHeight()
	)
	
end

--[[ functions used for feeling your way around the spritesheet
	a reel is a horizontal sequence of frames
	a clip is an individual frame in a reel
]]

local function updateViewport(self)
	self.quad:setViewport(
		self.clip.x, 
		self.clip.y, 
		self.clip.w, 
		self.clip.h
	)
end

function Actor_prototype:jumpReel(reel)
	self.clip.y = self.clip.h * reel;
end

function Actor_prototype:jumpClip(clip)
	self.clip.x = self.clip.w * clip
end

function Actor_prototype:nextClip()
	self.clip.x = self.clip.x + self.clip.w
end

function Actor_prototype:prevClip()
	self.clip.x = self.clip.x - self.clip.w
end

--[[	The updateClip method is called every frame for every Actor on the stack ]]

function Actor_prototype:draw()
	-- print(self)
	-- print(table.tostring(self))
	self.tick = self.tick - 1
	if self.animate then self:animate() end
	-- print(Player.x.."/"..Player.y)
	-- print("clip: " .. Player.clip.x .. "/" .. Player.clip.y .. "/" .. Player.clip.w .. "/" .. Player.clip.h)

	updateViewport(self)
	love.graphics.drawq(self.costume, self.quad, self.x, self.y)
end

--[[ lib is the public interface for the Actor module ]]

local stack = {}

local lib = {}

function lib.new(tag)
	a = {tag = tag}
	table.insert(stack, a)
	a.clip = {x = 0, y = 0, w = 0, h = 0}
	setmetatable(a, mt)
	print(table.tostring(a))
	return a
end

function lib.update()
	for k, v in ipairs(stack) do 
		if v.update then v:update() end
	end
end

function lib.draw()
	for k, v in ipairs(stack) do 
		if v.draw then v:draw() end
	end
end

return lib
