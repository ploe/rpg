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

local Item = {}
Item.effect = {}
Item.effect["Women's Shorts"] = "Shorts that seem to have magical side-effects in your own. Raises BONER stat by 50%, BUFF is SEMI-ON."
Item.effect["Peanuts"] = "Despite popular belief the peanut is not a legume it is a nut. FYI the peanut was invented by George Washington Carver when he was trying to invent Peanut Butter."
Item.effect["Generic Potion"] = "A generic RPG-esque potion that increases your HP a little. If only you knew what HP's were... If you drink lots of them quickly you'll want to take a HP"

local FONT_SIZE = 24
local font = love.graphics.setNewFont(FONT_SIZE)
love.graphics.setFont(font)
local sp = 1	-- stack pointer

function Bag.draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, 800, 600)
	local y = 0	
	for k,v in pairs(Bag.stock) do
		print(y.." vs "..y+1)
		love.graphics.setColor(255, 255, 255) 
		if y + 1 == sp then 
			love.graphics.printf(Item.effect[k] or "", 410, 0 , 390, "center")
			love.graphics.setColor(255, 0, 0)
		end
		love.graphics.printf(k .. "    x" .. v, 0, y * FONT_SIZE, 400, "right")
		love.graphics.setColor(255, 255, 255)
		y = y + 1
	end 
end

local blib = love.sound.newSoundData("sfx/blib.ogg")
function Bag.keypressed(key)
	local max = 0
	local b  = love.audio.newSource(blib)
	love.audio.play(b)
	if (key == "down") then 
		sp = sp + 1
	elseif (key == "up") then sp = sp - 1
    elseif(key == "a") then currentState = Game end
	for k in pairs(Bag.stock) do max = max + 1 end
	if sp < 1 then sp = 1 end
	print(key.." "..sp)
	 
end

Bag:add("Women's Shorts")
Bag:add("Peanuts")
Bag:add("Generic Potion")
