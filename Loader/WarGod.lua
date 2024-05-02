WarGod = LibStub("AceAddon-3.0"):NewAddon("WarGod", "AceConsole-3.0", "AceEvent-3.0")
local strlower = strlower
local gsub = gsub

WarGod.SimcraftifyString = function(text)
    if text == nil then return "" end
    return strlower(gsub(gsub(text, "%p", ""), "%s+", "_"))
end

WarGod.printTo = function(index, ...)
    --print(index)
    local frame = _G["ChatFrame" .. (index > 2 and index + 1 or index)]
    if (frame) then
        local printResult = ""
        for i,v in ipairs({...}) do
            printResult = printResult .. tostring(v) .. " "
        end
        --printResult = printResult .. "\n"
        --if lastMessages[index] ~= printResult then
        --lastMessages[index] = printResult
        frame:AddMessage(printResult)

        --end

    end
end