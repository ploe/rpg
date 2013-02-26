Bag = {}
Bag.stock = {}

local sp = 1	-- stack pointer
local max = 0	-- maximum value for stack pointer

local function updateMax()
	max = 0
	for k, v in pairs(Bag.stock) do max = max + 1 end
end

function Bag:add(item, amount)
	amount = amount or 1
	self.stock[item] = self.stock[item] or 0
	self.stock[item] = self.stock[item] + amount
	updateMax()
end

function Bag:pop(item)
	if not self.stock[item] then return end
	self.stock[item] = self.stock[item] - 1
	if self.stock[item] == 0 then self.stock[item] = nil end
	updateMax()
end

local Item = {}
Item = {}
Item["Women's Shorts"] = {
	flavour = "Shorts that seem to have magical side-effects in your own. Raises BONER stat by 50%, BUFF is SEMI-ON.",
	effect = function()
		print("BONER stat up by 50% and SEMI-ON is cast")
		Bag:pop("Women's Shorts")
	end
}

Item["Peanuts"] = {
	flavour = "Despite popular belief the peanut is not a legume it is a nut. FYI the peanut was invented by George Washington Carver when he was trying to invent Peanut Butter.",
	effect = function()
		print("OM NOM NOM")
		Bag:pop("Peanuts")
	end
}

Item["Generic Potion"] = {
	flavour = "A generic RPG-esque potion that increases your HP a little. If only you knew what HP's were... If you drink lots of them quickly you'll want to take a HP",
	effect = function()
		Bag:pop("Generic Potion")
	end
}

local FONT_SIZE = 24

function Bag.set()
	love.graphics.setNewFont(FONT_SIZE)
end

function Bag.draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, 800, 600)
	local y = 0	
	for k,v in pairs(Bag.stock) do
		love.graphics.setColor(255, 255, 255) 
		if y + 1 == sp then 
			love.graphics.printf(Item[k].flavour or "", 410, 0 , 390, "center")
			love.graphics.setColor(255, 0, 0)
		end
		love.graphics.printf(k .. "    x" .. v, 0, y * FONT_SIZE, 400, "right")
		love.graphics.setColor(255, 255, 255)
		y = y + 1
	end 
	love.graphics.setColor(255, 255, 255)
end

local blib = love.sound.newSoundData("sfx/blib.ogg")
function Bag.keypressed(key)
	local max = 0
	local b  = love.audio.newSource(blib)
	love.audio.play(b)
	if (key == "down") then 
		sp = sp + 1
	elseif (key == "up") then sp = sp - 1
    elseif(key == "a") then
		local i = 1
		for k, v in pairs(Bag.stock) do
			if i == sp then
				Item[k].effect()
				break 
			end
			i = i + 1
		end
	elseif key == 'return' then setState(Game) end

	for k in pairs(Bag.stock) do max = max + 1 end
	if max >= 1 and sp < 1 then sp = 1 end 
	if sp > max then sp = max end 
end

Bag:add("Women's Shorts")
Bag:add("Peanuts", 7)
Bag:add("Generic Potion", 42)
