--[[ An Actor is the basic Sprite type ]]

local Actor_prototype = {
	x = 0, y = 0, h = 0, w = 0,					-- offset dimensions
	costume,									-- image, spritesheet
	clip = { x = 0, y = 0, w = 0, h = 0 },		-- quad dimenstions
	scale = 1,
	aura										-- bounding box
}

local mt = {}
mt.__index = Actor_prototype

function Actor_prototype:loadcostume(filename, w, h, scale)
	self.image = love.graphics.newImage(filename)
	if not self.image then
		print("Image not found, failed")
		return
	end
	self.clip.w = w; self.clip.h = h
	self.quad = love.graphics.newQuad (
		self.clip.x,
		self.clip.y,
		self.clip.w, 
		self.clip.h, 
		self.image:getWidth(),
		self.image:getHeight()
	)
	
end

--[[ functions used for feeling your way around the spritesheet
	a reel is a horizontal sequence of frames
	a clip is an individual frame in a reel
]]

local function updateviewport(self)
	self.quad:setViewport(
		self.clip.x, 
		self.clip.y, 
		self.clip.w, 
		self.clip.h
	)
end

function Actor_prototype:jumpreel(reel)
	self.clip.y = self.clip.h * reel;
	updateviewport(self)
end

function Actor_prototype:jumpclip(clip)
	self.clip.x = self.clip.w * clip
	updateviewport(self)
end

function Actor_prototype:nextclip()
	self.clip.x = self.clip.x + self.clip.w
	updateviewport(self)
end

function Actor_prototype:prevclip()
	self.clip.x = self.clip.x - self.clip.w
	updateviewport(self)
end

--[[ lib is the public interface for the Actor module ]]

local lib = {}

function lib.new(tag)
	a = {tag = tag}
	setmetatable(a, mt)
	return a
end


return lib
