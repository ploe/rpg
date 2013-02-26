Bag = {}
Bag.stock = {}
function Bag:add(item)
	self.stock[item] = self.stock[item] or 0
	self.stock[item] = self.stock[item] + 1
end

function Bag:pop(item)
	if not self.stock[item] then return end
	self.stock[item] = self[item] - 1
	if self.stock[item] == 0 then self[item] = nil end
end

local FONT_SIZE = 24

function Bag.set()
	love.graphics.setNewFont(FONT_SIZE)
end

function Bag.draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, 800, 600)
	love.graphics.setColor(200, 200, 201)
	local y = 0	
	for k,v in pairs(Bag.stock) do
		love.graphics.printf(k .. "    x" .. v, 0, y, 400, "right")
		y = y + FONT_SIZE
	end 
	love.graphics.setColor(255, 255, 255)
end

local blib = love.sound.newSoundData("sfx/blib.ogg")
local sp = 1
function Bag.keypressed(key)
	local max = 0
	local b  = love.audio.newSource(blib)
	love.audio.play(b)
	for k in pairs(Bag.stock) do max = max + 1 end
	if key == 'return' then
		setState(Game)
	end
	 
end

Bag:add("Women's Shorts")
Bag:add("Peanuts")
