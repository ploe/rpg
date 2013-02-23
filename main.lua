Actor = require("Actor")
require("Action")
require('Map')
require('Editor')
require('Player')

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

function love.mousepressed(x, y, button)
	Editor.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Editor.mousereleased(x, y, button)
end

function love.draw()
	love.graphics.setCaption("Baggage Reclaim Man - Gotta LOVE lime")
	Editor.draw()
	Action:update()
	Actor.draw()
	if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
	Signal = {}
end

