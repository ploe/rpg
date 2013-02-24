Bag = {}
Bag.stock = {}
function Bag:add(item)
	self.stock[item] = self.stock[item] or 0
	self.stock[item] = self.stock[item] + 1
end

function Bag:pop(item)
	if not self.stock[item] then return end
	self.stock[item] = self[item] - 1
	if self.stock[item] == nil then self[item] = nil end
end
local FONT_SIZE = 24
local font = love.graphics.setNewFont(FONT_SIZE)
love.graphics.setFont(font)
function Bag:draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, 800, 600)
	love.graphics.setColor(200, 200, 201)
	local y = 0	
	for k,v in pairs(Bag.stock) do
		love.graphics.printf(k .. "    x" .. v, 0, y, 400, "right")
		y = y + FONT_SIZE
	end 
end

Bag:add("Women's Shorts")
Bag:add("Peanuts")
