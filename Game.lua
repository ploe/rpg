-- The main game
Game = {}

-- A thing centered should be on 400, 300
local function centerCamera(x, y)
    xOff = 400 - x
    yOff = 300 - y
end

local function clamp(v, mi, ma)
    if v < mi then v = mi end
    if v > ma then v = ma end
    return v
end

-- Clamp camera to map edges
local function clampCamera()
    xOff = clamp(xOff, -(Map.map.width - 25) * 32 , 0)
    yOff = clamp(yOff, -(Map.map.height - 19) * 32, 0)
end

function Game.update()
end

function Game.set()
    love.graphics.setCaption("RPG - "..Map.map.name)
end

function Game.mousepressed(x, y, button)
    if devmode then
        -- Teleport player with mouse
        Player.grid.x = math.floor((x - xOff) / 32) + 1
        Player.grid.y = math.floor((y - yOff) / 32) + 1
        Player.x = (Player.grid.x - 1) * 32
        Player.y = (Player.grid.y - 1) * 32 - 12
    end
end

function Game.keypressed(key, unicode)
    if key == 'return' then
        if devmode and love.keyboard.isDown('lctrl') then
            setState(Editor)
        elseif not love.keyboard.isDown('lalt') then
            setState(Bag)
        end
    end
end

function Game.draw()
    centerCamera(Player.x + 16, Player.y + 24)
    clampCamera()
    love.graphics.translate(xOff, yOff)
    Map.draw()
    Action:update()
    Actor.draw()
end
