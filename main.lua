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

function love.draw()
	love.graphics.push()
	centerCamera(Player.x + 16, Player.y + 24)
	love.graphics.translate(xOff, yOff)
	Editor.drawMap()
	Action:update()
	Actor.draw()
	love.graphics.pop()
	Editor.drawUI()
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
	Signal = {}
end

