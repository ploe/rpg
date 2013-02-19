Action = {}			--	An Action is a type of callback class
function Action:update()	--	loops over every single Action
	for k, value in ipairs(self) do value:update() end
end

function Action:push(a, tag)
	a.tag = tag
	if type(a) ~= "table" or type(a.update) ~= "function" then
		print("Action isn't the right spec to be pushed")
		return 
	end
	table.insert(self, a)
end

Signal = {}

local InputDaemon = {}
--[[ The keys we want mapping ]]
InputDaemon.keys = {
	up = "up",
	down = "down",
	left = "left",
	right = "right"
}

function InputDaemon:update()
	for key, value in pairs(self.keys) do
		if love.keyboard.isDown(value) then Signal[key .. " pressed"] = true end
	end
end

Action:push(InputDaemon, "InputDaemon")

function InputDaemon.logKeys()

end


