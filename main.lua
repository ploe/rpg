Actor = require("Actor")
require("Action")
require('Map')
require('Editor')
require('Player')
require('Game')
require('Bag')

-- Camera offset
xOff = 0
yOff = 0

function setState(state)
    if currentState and currentState.unset then currentState.unset() end
    currentState = state
    if currentState.set then currentState.set() end
end

function love.load()
    JIFFY = 1/30
    Action:push(Player)
    if not Map.load("plains.lua") then
        print('Failed to load map')
        love.event.quit()
        end
    
    Editor.init()
    setState(Game)
end

function love.update()
    start = love.timer.getMicroTime()
    if currentState.update then currentState.update() end
end

function love.keypressed(key, unicode)
    if key == 'return' and love.keyboard.isDown('lalt') then
        love.graphics.toggleFullscreen()
    end
    if currentState.keypressed then currentState.keypressed(key, unicode) end
end

function love.mousepressed(x, y, button)
    if currentState.mousepressed then currentState.mousepressed(x, y, button) end
end

function love.mousereleased(x, y, button)
    if currentState.mousereleased then currentState.mousereleased(x, y, button) end
end

function love.draw()
    if currentState.draw then currentState.draw() end
    if love.timer.getMicroTime() <= start + JIFFY then love.timer.sleep(start + JIFFY - love.timer.getMicroTime()) end
    Signal = {}
end

