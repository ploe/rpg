local tiles =
{
    source = 'village.png',
    tileWidth = 32,
    tileHeight = 32,
    
    -- Grass
    {
        solid = false,
        offset = {x = 0, y = 0}
    }
    ,
    -- Window thingy for transparency/layer2 test
    {
        solid = true,
        offset = {x = 32, y = 352}
    }
}

return tiles
