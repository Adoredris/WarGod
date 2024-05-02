local GetTime = GetTime
local setmetatable = setmetatable
local rawset = rawset
local pairs = pairs

local _null = "null"

--WarGod.BossMods["default"]["targeting"] = function() printTo(3,'silly') end
local WGBM = WarGod.BossMods
local frame = CreateFrame("Frame")

local lastDamagedEventsTimeTable = {}
--WGBM.lastDamagedEventsTimeTable = lastDamagedEventsTimeTable
setmetatable(lastDamagedEventsTimeTable, {__index = function(t, spell)
    rawset(lastDamagedEventsTimeTable, spell, 0)
    return 0
end})

local DamageEvents = {}
WGBM.DamageEvents = DamageEvents


function DamageEvents:COMBAT_LOG_EVENT_UNFILTERED(event)
    local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
    --print("COMBAT_LOG_EVENT_UNFILTERED")
    if WarGod.Unit:GetPlayer().guid == destGUID then
        --print("on player")
        --print(CombatLogGetCurrentEventInfo())
        if strmatch(eventname, "DAMAGE$") or strmatch(eventname, "ABSORBED$") then
            if type(spellName) == "string" then
                lastDamagedEventsTimeTable[spellName] = GetTime()

            end
        end
    end
end

function DamageEvents:PLAYER_REGEN_ENABLED(event)
    for k,v in pairs(lastDamagedEventsTimeTable) do
        lastDamagedEventsTimeTable[k] = nil
    end
end


function WGBM:TimeSinceLastDamagedBy(spell)
    return GetTime() - lastDamagedEventsTimeTable[spell]
end

frame:SetScript("OnEvent", function(self, event, ...)
    DamageEvents[event](self, event, ...); -- call one of the functions above
end)
--[[function EventHandlers:ADDON_LOADED(...)
    print(...)
end]]

for k, v in pairs(DamageEvents) do
    frame:RegisterEvent(k);
end