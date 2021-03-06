--[[
Chop a tree to the front while keeping
Drawers behind. Ideally the controller
is the block directly behind to drop
inventory properly.

Tested on Minecraft 1.12.2
--]]
lumberjack = require("lumberjack_legacy")

while true do
    _, blockInFront = turtle.inspect()
    name = blockInFront["name"]
    
    if name and string.match(name, lumberjack.LOG_PATTERN) then
        lumberjack.chop()
        lumberjack.checkFuel(500)
        turtle.turnLeft()
        turtle.turnLeft()
        lumberjack.unload()
        turtle.turnLeft()
    end
    print("No tree found, try to plant and fertilize...")
    lumberjack.replant()
    lumberjack.fertilize()
    os.sleep(1)
end
