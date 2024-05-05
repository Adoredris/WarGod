WarGod = LibStub("AceAddon-3.0"):NewAddon("WarGod", "AceConsole-3.0", "AceEvent-3.0")
local strlower = strlower
local gsub = gsub

local simcraftifyMap = {}

WarGod.SimcraftifyString = function(text)
    if text == nil then return "" end
    if not simcraftifyMap[text] then
        simcraftifyMap[text] = strlower(gsub(gsub(text, "%p", ""), "%s+", "_"))
    end
    return simcraftifyMap[text]
end

local lastMessages = {}
function WarGod.printTo(index, ...)
    --print(index)
    local frame = _G["ChatFrame" .. (index > 2 and index + 1 or index)]
    if (frame) then
        local printResult = ""
        for i,v in ipairs({...}) do
            printResult = printResult .. tostring(v) .. " "
        end
        --printResult = printResult .. "\n"
        if lastMessages[index] ~= printResult then
            lastMessages[index] = printResult
            frame:AddMessage(printResult)

        end

    end
end

local debug = true

function WarGod.printdebug(msg)
    if debug then
        WarGod.printTo(4, msg)
    end
end