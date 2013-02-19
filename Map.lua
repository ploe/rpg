--[[ A tile-based map ]]

Map = {}

-- Generate texture quads for each tile in the tileset
local function genQuads()
    for i = 1, table.getn(Map.tileset) do
        local tile = Map.tileset[i]
        tile.quad = love.graphics.newQuad(tile.offset.x, tile.offset.y, Map.tileset.tileWidth, Map.tileset.tileHeight, Map.image:getWidth(), Map.image:getHeight())
    end
end

function Map.load(filename)
    local path = 'maps/'..filename
    -- File validity check
    if not love.filesystem.exists(path) or not love.filesystem.isFile(path) then
        return false
    end
    
    -- Read and execute map as lua script
    local data = love.filesystem.read(path)
    Map.map = assert(loadstring(data))()
        
    -- Load tileset
    local prefix = 'tilesets/'
    data = love.filesystem.read(prefix..Map.map.tileset..'.lua')
    Map.tileset = assert(loadstring(data))()
    Map.image = love.graphics.newImage(prefix..Map.tileset.source)
    Map.batch = {}
    genQuads()
    
    -- Set up a sprite batch for each layer
    for l = 1, Map.map.layers.count do
        Map.batch[l] = love.graphics.newSpriteBatch(Map.image)
        Map.updateBatch(l)
    end
    Map.filename = filename
    return true
end

require('tabletostring')

function Map.saveToFile(filename)
    local path = 'maps/'..filename
    love.filesystem.mkdir('maps')
    local data = 'return '..table.tostring(Map.map)
    love.filesystem.write(path, data)
    Map.filename = filename
end

function Map.updateBatch(layer)
    Map.batch[layer]:clear()
    for y = 1, Map.map.height do
        for x = 1, Map.map.width do
            -- Get Map.tileset tile
            local idx = Map.map.layers[layer][y][x]
            if idx ~= 0 then
                local tile = Map.tileset[idx]
                if tile == nil then
                    print('['..prefix..Map.map.tileset..'.lua] Bad tile: '..idx)
                    return false
                end
                -- Add to the sprite batch
                Map.batch[layer]:addq(tile.quad, (x - 1) * Map.tileset.tileWidth, (y - 1) * Map.tileset.tileHeight)
            end
        end
    end
end

function Map.resize(w, h)
    local oldW = Map.map.width
    local oldH = Map.map.height
    Map.map.width = w
    Map.map.height = h
    -- Update map and if there are nil tiles, set them to 0
    for l = 1, Map.map.layers.count do
        for y = 1, Map.map.height do
            if Map.map.layers[l][y] == nil then
                Map.map.layers[l][y] = {}
            end
            for x = 1, Map.map.width do
                if Map.map.layers[l][y][x] == nil then
                    Map.map.layers[l][y][x] = 0
                end
            end
        end
        Map.updateBatch(l)
    end
end

function Map.draw()
    for l = 1, Map.map.layers.count do
        love.graphics.draw(Map.batch[l])
    end
end
