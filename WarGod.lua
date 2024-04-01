WarGod = LibStub("AceAddon-3.0"):NewAddon("WarGod", "AceConsole-3.0", "AceEvent-3.0")
local strlower = strlower
local gsub = gsub

WarGod.SimcraftifyString = function(text)
    if text == nil then return "" end
    return strlower(gsub(gsub(text, "%p", ""), "%s+", "_"))
end