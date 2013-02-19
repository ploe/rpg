--[[Map Editor]]

Editor = {}

local function TileCursorInBounds()
    return Editor.tx <= Map.map.width and Editor.ty <= Map.map.height
end

local function pixToTileCoord(x, y)
    return math.floor(x / 32) + 1, math.floor(y / 32) + 1
end

-- Tools
local tools =
{    
    {
        name = 'Eraser',
        quadOffset = {0, 0},
        exec = function()
            Editor.tile = 0
        end
    },
    {
        name = 'Reload',
        quadOffset = {64, 0},
        exec = function()
            Map.load(Map.filename)
        end
    },
    {
        name = 'Load',
        quadOffset = {0, 32},
        exec = function()
            -- Todo: This reads filename from stdin
            -- Can't be used without a console open
            filename = io.read()
            Map.load(filename)
            love.graphics.setCaption(Map.filename)
        end
    },
    {
        name = 'Save',
        quadOffset = {96, 0},
        exec = function()
            Map.saveToFile(Map.filename)
        end
    },
    {
        name = 'Save As',
        quadOffset = {64, 32},
        exec = function()
            -- Todo: This reads filename from stdin
            -- Can't be used without a console open
            filename = io.read()
            Map.saveToFile(filename)
            love.graphics.setCaption(Map.filename)
        end
    },
    {
        name = 'New (Not implemented)',
        quadOffset = {96, 32},
        exec = function()
        end
    },
    {
        name = 'Toggle fade inactive layers',
        quadOffset = {32, 32},
        exec = function()
            Editor.fadeInactiveLayers = not Editor.fadeInactiveLayers
        end
    },
    {
        name = 'Resize',
        quadOffset = {32, 0},
        exec = function()
            -- Todo: This reads the new size from stdin
            -- Can't be used without a console open
            local newW = io.read('*number')
            local newH = io.read('*number')
            if newW > 0 and newH > 0 then
                Map.resize(newW, newH)
            end
        end
    }
}

function Editor.init()
    Editor.layer = 1
    Editor.image = love.graphics.newImage('img/editor.png')
    Editor.tile = 1
    Editor.fadeInactiveLayers = false
    love.graphics.setCaption(Map.filename)
    -- Create quads for the tools
    for t = 1, table.getn(tools) do
        tools[t].quad = love.graphics.newQuad(tools[t].quadOffset[1], tools[t].quadOffset[2], 32, 32, Editor.image:getWidth(), Editor.image:getHeight())
    end
end

function Editor.update()
    Editor.tx, Editor.ty = pixToTileCoord(love.mouse.getX(), love.mouse.getY())
    if love.mouse.isDown('l') and TileCursorInBounds() then
        Map.map.layers[Editor.layer][Editor.ty][Editor.tx] = Editor.tile
        Map.updateBatch(Editor.layer)
    end
end

function Editor.draw()
    -- Draw layers of map
    for l = 1, Map.map.layers.count do
        if l ~= Editor.layer and Editor.fadeInactiveLayers then
            love.graphics.setColor(255, 255, 255, 128)
        end
        love.graphics.draw(Map.batch[l])
        love.graphics.setColor(255, 255, 255)
    end
    if TileCursorInBounds() then
        -- Draw a rectangle at current tile position
        love.graphics.setColor(255, 0, 0, 96)
        love.graphics.rectangle('fill', (Editor.tx - 1) * 32, (Editor.ty - 1) * 32, 32, 32)
        love.graphics.setColor(255, 255, 255)
    end
    -- Draw map bounds
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('line', 0, 0, Map.map.width * 32, Map.map.height * 32)
    love.graphics.setColor(255, 255, 255)
    -- Draw available tiles in tileset
    for i = 1, table.getn(Map.tileset) do
        love.graphics.drawq(Map.image, Map.tileset[i].quad, (i - 1) * 32, 600 - 64)
    end
    -- Highlight selected tile
    love.graphics.setColor(255, 255, 255, 128)
    if Editor.tile == 0 then
        love.graphics.rectangle('fill', 0, 600 - 32, 32, 32)
    else
        love.graphics.rectangle('fill', (Editor.tile - 1) * 32, 600 - 64, 32, 32)
    end
    love.graphics.setColor(255, 255, 255)
    -- Draw buttons for layer selection
    for l = 1, Map.map.layers.count do
        method = 'line'
        if l == Editor.layer then method = 'fill' end
        love.graphics.rectangle(method, 800 - 32, (l - 1) * 32, 32, 32)
    end
    -- Draw buttons for tools
    for t = 1, table.getn(tools) do
        love.graphics.drawq(Editor.image, tools[t].quad, (t - 1) * 32, 600 - 32)
    end
    -- Draw overlay info for
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    -- tiles
    if my >= 600 - 64 and my < 600 - 32 then
        local tile = pixToTileCoord(mx, my)
        if tile <= table.getn(Map.tileset) then
            if Map.tileset[tile].solid then
                love.graphics.print('solid', mx, my - 16)
            end
        end
    end
    -- tools
    if my >= 600 - 32 then
        local tool = pixToTileCoord(mx, my)
        if tool <= table.getn(tools) then
            love.graphics.print(tools[tool].name, mx, my - 16)
        end
    end
end

function Editor.mousepressed(x, y, button)
    -- Layer select
    if x >= 800 - 32 then
        local discard
        discard, Editor.layer = pixToTileCoord(x, y)
    end
    -- Tile select
    if y >= 600 - 64 and y < 600 - 32 then
        Editor.tile = pixToTileCoord(x, y)
        if Editor.tile > table.getn(Map.tileset) then
            Editor.tile = table.getn(Map.tileset)
        end
    end
    -- Tool select
    if y >= 600 -32 then
        local tool = pixToTileCoord(x, y)
        if tool <= table.getn(tools) then
            tools[tool].exec()
        end
    end
end

function Editor.save()
    
end