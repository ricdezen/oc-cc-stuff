lumberjack = require("lumberjack")

function findDrawers()
    last = nil
    while true do
        front = peripheral.wrap("front")
        if (not front) and last then
            return
        end
        last = front
        turtle.turnLeft()
    end
end

findDrawers()

while true do
    _, blockInFront = turtle.inspect()
    name = blockInFront["name"]
    
    if name and string.match(name, lumberjack.LOG_PATTERN) then
        lumberjack.chop()
        lumberjack.checkFuel(500)
        turtle.turnLeft()
        turtle.turnLeft()
        lumberjack.unload()
        turtle.turnRight()
        turtle.turnRight()
    end
    print("No tree found, try to plant and fertilize...")
    lumberjack.replant()
    lumberjack.fertilize()
    os.sleep(1)
end
