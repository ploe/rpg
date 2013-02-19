--[[ A tile-based map ]]

Map = {}

-- Validate a map
-- Returns true if map is valid
-- Returns false if map is not valid
local function validate(map)
    -- Check length of each layer
    for i = 1, map.layers.count do
        if table.getn(map.layers[i]) ~= map.width * map.height then
            print('Invalid length \''..table.getn(map.layers[i])..'\' for layer '..i)
            print('Should have length of '..map.width * map.height)
            return false
        end
    end
    
    return true
end

function Map.loadFromFile(filename)
    -- File validity check
    if not love.filesystem.exists(filename) or not love.filesystem.isFile(filename) then
        return false
    end
    
    -- Read and execute map as lua script
    local data = love.filesystem.read(filename)
    Map.map = assert(loadstring(data))()
    
    if not validate(Map.map) then
        return false
    end
    
    -- Load tileset
    local prefix = 'tilesets/'
    data = love.filesystem.read(prefix..Map.map.tileset..'.lua')
    Map.tileset = assert(loadstring(data))()
    Map.image = love.graphics.newImage(prefix..Map.tileset.source)
    Map.batch = {}
    
    -- Set up a sprite batch for each layer
    for l = 1, Map.map.layers.count do
        Map.batch[l] = love.graphics.newSpriteBatch(Map.image)
        for y = 1, Map.map.height do
            for x = 1, Map.map.width do
                -- Get Map.tileset tile
                local idx = Map.map.layers[l][(y - 1) * Map.map.width + x]
                if idx ~= 0 then
                    local tile = Map.tileset[idx]
                    if tile == nil then
                        print('['..prefix..Map.map.Map.tileset..'.lua] Bad tile: '..idx)
                        return false
                    end
                    -- Add to the sprite batch
                    local quad = love.graphics.newQuad(tile.offset.x, tile.offset.y, Map.tileset.tileWidth, Map.tileset.tileHeight, Map.image:getWidth(), Map.image:getHeight())
                    Map.batch[l]:addq(quad, (x - 1) * Map.tileset.tileWidth, (y - 1) * Map.tileset.tileHeight)
                end
            end
        end
    end
    return true
end

function Map.draw()
    for l = 1, Map.map.layers.count do
        love.graphics.draw(Map.batch[l])
    end
end
