-----------------------
-- Map: Tile based map
-----------------------

Map = {}

-- Generate texture quads for each tile in the tileset
local function genQuads()
    for i = 1, table.getn(Map.tileset) do
        local tile = Map.tileset[i]
        tile.quad = love.graphics.newQuad(tile.offset.x, tile.offset.y, Map.tileset.tileWidth, Map.tileset.tileHeight, Map.image:getWidth(), Map.image:getHeight())
    end
end

-- Load the map from a map file
-- It looks in maps/ for the map file
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

-- Save the map to a file
-- It saves in maps/
function Map.saveToFile(filename)
    local path = 'maps/'..filename
    love.filesystem.mkdir('maps')
    local data = 'return '..table.tostring(Map.map)
    love.filesystem.write(path, data)
    Map.filename = filename
end

-- Update the layer's LOVE tilebatch used to draw the map
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
                Map.batch[layer]:add(tile.quad, (x - 1) * Map.tileset.tileWidth, (y - 1) * Map.tileset.tileHeight)
            end
        end
    end
end

-- Resize the map
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

-- Add a layer
function Map.addLayer()
    Map.map.layers.count = Map.map.layers.count + 1
    local l = Map.map.layers.count
    Map.map.layers[l] = {}
    Map.batch[l] = love.graphics.newSpriteBatch(Map.image)
    Map.resize(Map.map.width, Map.map.height)
end

-- Remove layer l
function Map.removeLayer(l)
    table.remove(Map.map.layers, l)
    Map.map.layers.count = Map.map.layers.count - 1
end

-- Draw the map
function Map.draw()
    for l = 1, Map.map.layers.count do
        love.graphics.draw(Map.batch[l])
    end
end

-- Get info about the tile at (layer, x, y)
function Map.tileInfo(layer, x, y)
	if layer > 0 and  x > 0 and y > 0 then return Map.tileset[Map.map.layers[layer][y][x]] end
	return nil
end

-- Check if a tile is solid at (layer, x, y)
function Map.isSolid(layer, x, y)
    local info = Map.tileInfo(layer, x, y)
    if info and info.solid then return true else return false end
end
