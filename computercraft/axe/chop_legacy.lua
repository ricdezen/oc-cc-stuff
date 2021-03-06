--[[
Chop a tree to the front. A sapling inventory
should be to the left. A fertilizer inventory
should be at the back. An output inventory should
be to the right.

Tested on Minecraft 1.12.2
--]]
lumberjack = require("lumberjack_legacy")

while true do
    _, blockInFront = turtle.inspect()
    name = blockInFront["name"]
    
    if name and string.match(name, lumberjack.LOG_PATTERN) then
        lumberjack.chop()
        lumberjack.checkFuel(500)
        turtle.turnRight()
        lumberjack.unload()
        turtle.turnLeft()
    end
    print("No tree found, try to plant and fertilize...")
    lumberjack.replant(SAPLING_NAME)
    lumberjack.fertilize(FERTILIZER_NAME)
    os.sleep(1)
end
