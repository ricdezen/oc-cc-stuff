--[[
Changes the resolution
Expects two command lines arguments, the width and height of the resolution
Must be valid values for the current screen
--]]

local component = require("component")

local gpu = component.gpu

local arg = {...}

gpu.setResolution(tonumber(arg[1]), tonumber(arg[2]))
