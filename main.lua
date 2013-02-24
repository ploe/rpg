Actor = require("Actor")
require("Action")
require('Map')
require('Editor')
require('Player')

-- Camera offset
xOff = 0
yOff = 0

function love.load()
	JIFFY = 1/30
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

function love.keypressed(key, unicode)
	if key == 'return' and love.keyboard.isDown('lalt') then
		love.graphics.toggleFullscreen()
	end
end

function love.mousepressed(x, y, button)
	Editor.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Editor.mousereleased(x, y, button)
end

-- A thing centered should be on 400, 300
function centerCamera(x, y)
	xOff = 400 - x
	yOff = 300 - y
end

function clamp(v, mi, ma)
	if v < mi then v = mi end
	if v > ma then v = ma end
	return v
end

-- Clamp camera to map edges
function clampCamera()
	xOff = clamp(xOff, -(Map.map.width - 25) * 32 , 0)
	yOff = clamp(yOff, -(Map.map.height - 19) * 32, 0)
end

function love.draw()
	love.graphics.push()
	centerCamera(Player.x + 16, Player.y + 24)
	clampCamera()
	love.graphics.translate(xOff, yOff)
	Editor.drawMap()
	Action:update()
	Actor.draw()
	love.graphics.pop()
	Editor.drawUI()
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
	Signal = {}
end

