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
    local myMap = assert(loadstring(data))()
    
    if not validate(myMap) then
        return false
    end
    
    -- Load tileset
    local prefix = 'tilesets/'
    data = love.filesystem.read(prefix..myMap.tileset..'.lua')
    local tileset = assert(loadstring(data))()
    local image = love.graphics.newImage(prefix..tileset.source)
    Map.batch = {}
    
    -- Set up a sprite batch for each layer
    for l = 1, myMap.layers.count do
        Map.batch[l] = love.graphics.newSpriteBatch(image)
        for y = 1, myMap.height do
            for x = 1, myMap.width do
                -- Get tileset tile
                local idx = myMap.layers[l][(y - 1) * myMap.width + x]
                if idx ~= 0 then
                    local tile = tileset[idx]
                    if tile == nil then
                        print('['..prefix..myMap.tileset..'.lua] Bad tile: '..idx)
                        return false
                    end
                    -- Add to the sprite batch
                    local quad = love.graphics.newQuad(tile.offset.x, tile.offset.y, tileset.tileWidth, tileset.tileHeight, image:getWidth(), image:getHeight())
                    Map.batch[l]:addq(quad, (x - 1) * tileset.tileWidth, (y - 1) * tileset.tileHeight)
                end
            end
        end
    end
    
    -- Assign map reference
    Map.map = myMap
    
    return true
end

function Map.draw()
    for l = 1, Map.map.layers.count do
        love.graphics.draw(Map.batch[l])
    end
end
