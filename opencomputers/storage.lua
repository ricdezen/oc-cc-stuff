local component = require("component")
local event = require("event")
local sides = require("sides")
local term = require("term")

local inv = component.transposer
local gpu = component.gpu

-- table with the info about the storage. Should contain numerical keys (the slot number)
-- and table values, these tables should have the keys as declared below.
local storage_info = {}
local label_key = "l"
local size_key = "s"
local scan_log = "Scanning slot %s out of %s"

local exit_char = string.byte("q")
local down_char = string.byte("s")
local up_char = string.byte("w")

local up_arrow = " <--- "
local down_arrow = " ---> "

local storage_side = sides.front

local stack_meta
local lines
local inv_size = 0
local max_width
local view_end
local view_start = 1
local start_x = 0
local end_x = 0
local start_y = 0
local end_y = 0

-- prints an up arrow to the first line or clears said line
local function upArrow(enabled)
  local old_x, old_y = term.getCursor()
  term.setCursor(start_x, start_y)
  term.clearLine()
  if enabled then
    term.write(up_arrow)
  end
  term.setCursor(old_x, old_y)
end

-- prints a down arrow to the last text line or clears said line
local function downArrow(enabled)
  local old_x, old_y = term.getCursor()
  term.setCursor(start_x, end_y - 1)
  term.clearLine()
  if enabled then
    term.write(down_arrow)
  end
  term.setCursor(old_x, old_y)
end

-- print the one line of the buffer, clear current line and moves to start
-- @param label: the name of the item, string only
-- @param size: the size of the stack, numbers and strings are allowed
local function printItem(label, size)
  local size_str = tostring(size)
  term.clearLine()
  local x, y = term.getCursor()
  term.setCursor(start_x, y)
  term.write(label, false)
  term.setCursor(end_x - size_str:len(), y)
  term.write(size_str, false)
  term.setCursor(start_x, y+1)
end

-- print all the items in "storage_info", uses numerical keys only
local function printAll()
  term.setCursor(start_x, start_y + 1)
  view_end = view_start + lines - 1
  upArrow(view_start > 1)
  downArrow(view_end < inv_size)
  for i = view_start, view_end do
    local row = storage_info[i]
    if row then
      printItem(row[label_key], row[size_key])
    end
  end
end

-- move the cursor up if possible
local function moveUp()
  if view_start == 1 then return end
  view_start = view_start - 1
  term.clear()
  printAll()
end

-- move the cursor down if possible
local function moveDown()
  if view_end == inv_size then return end
  view_start = view_start + 1
  term.clear()
  printAll()
end

-- callback for quit action
local function keyPressed(id, address, char, code, player)
  if not id then return end
  if not char then return end
  if char == exit_char then os.exit() end
  if char == up_char then moveUp() end
  if char == down_char then moveDown() end
end

-- put all of an inventory's stacks info into the "storage_info" table
-- The key will be an incrementing number, the value will be a table
-- @param side: the side of the inventory
local function scanInv(side)  
  local old_x, old_y = term.getCursor()
  local cursor = 1
  -- resetting info table to avoid redundant lines
  local temp_info = {}
  local storage_size = inv.getInventorySize(side)
  for i = 1, storage_size do
    term.setCursor(start_x, end_y)
    term.clearLine()
    term.write(string.format(scan_log, i, storage_size), false)
    stack_meta = inv.getStackInSlot(storage_side, i)
    if stack_meta then
      local data = {}
      data[label_key] = stack_meta.label
      data[size_key] = stack_meta.size
      temp_info[cursor] = data
      cursor = cursor + 1
    end
    keyPressed(event.pull(0, "key_down"))
  end
  inv_size = cursor
  storage_info = temp_info
  term.setCursor(old_x, old_y)
end

-- SCRIPT START

start_x = 1
start_y = 1
end_x, end_y = gpu.getResolution()
lines = end_y - start_y - 2
max_width = end_x - start_x + 1
view_end = view_start + lines - 1

while true do
  scanInv(storage_side)
  printAll()
end