--[[
Chop a tree to the front. A sapling inventory
should be to the left. A fertilizer inventory
should be at the back. An output inventory should
be to the right.
All sides except the tree side must be occupied.

Tested on Minecraft 1.12.2
--]]
lumberjack = require("lumberjack_legacy")

SAPLING_NAME = "minecraft:sapling"

function findOrientation()
    local mayBeLog = false
    while not mayBeLog do
        local anything, blockInFront = turtle.inspect()
        if not anything then
            mayBeLog = true
        else
            local name = blockInFront["name"]
            if name and string.match(name, lumberjack.LOG_PATTERN) then
                mayBeLog = true
            end
            if name == SAPLING_NAME then
                mayBeLog = true
            end
        end
    end
end

function cycle()
    lumberjack.chop()
    lumberjack.checkFuel(500)
    turtle.turnRight()
    lumberjack.unload()
    turtle.turnLeft()
end

-- Try to chop in case you got stuck mid-air
lumberjack.cycle()
-- Try to orient yourself
findOrientation()

while true do
    _, blockInFront = turtle.inspect()
    name = blockInFront["name"]
    
    if name and string.match(name, lumberjack.LOG_PATTERN) then
        
    end
    print("No tree found, try to plant and fertilize...")
    lumberjack.replant()
    lumberjack.fertilize()
    os.sleep(1)
end
