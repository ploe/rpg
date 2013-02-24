local tiles =
{
    source = 'village.png',
    tileWidth = 32,
    tileHeight = 32,
    
    -- Grass
    {
        offset = {x = 0, y = 0}
    },
    -- Tall grass
    {
        offset = {x = 32, y = 0}
    },
    -- Desert
    {
        offset = {x = 64, y = 0}
    },
    -- Wood
    {
        offset = {x = 448, y = 448}
    },
    -- Black wall
    {
        offset = {x = 64, y = 256}
    },
    -- Door (upper)
    {
        offset = {x = 512, y = 588}
    },
    -- Door (lower)
    {
        offset = {x = 512, y = 588 + 32}
    },
    -- Window thingy for transparency/layer2 test
    {
        offset = {x = 32, y = 352},
        solid = true
    },
    -- Chess1
    {
        offset = {x = 448, y = 480}
    },
    -- Chess2
    {
        offset = {x = 480, y = 480}
    },
    -- Chess3
    {
        offset = {x = 512, y = 480}
    },
}

return tiles
