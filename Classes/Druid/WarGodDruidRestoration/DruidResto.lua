if UnitClass("player") ~= "Druid" then C_AddOns.DisableAddOn("WarGodDruidRestoration"); return end
local Druid = WarGod.Class
local Resto = {}
local frame = CreateFrame("Frame")

local Class = WarGod.Class
local player = WarGod.Unit:GetPlayer()
local Rotations = WarGod.Rotation
local groups = WarGod.Unit.groups

local GetSpecialization = GetSpecialization
local print = print
local pairs = pairs
local upairs = upairs
local GetTime = GetTime
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local print = print

setfenv(1, Rotations)

function Delegates:EnoughWildGrowthTargets(spell, theUnit, args)
    --print('EnoughWildGrowthTargets')
    local numPlayers = 0
    for guid,unit in upairs(groups.targetable) do
        local allTrue = true
        if Delegates:IsSpellInRange("Rejuvenation", unit, args) then
            for k,delegate in pairs(args.andDelegates) do
                --print(k)
                if (not delegate(spell,unit, args)) then
                    allTrue = false
                    break
                end
            end
            if allTrue == true then
                numPlayers = numPlayers + 1
            end
        end
    end
    return numPlayers >= (args.targets or 4)
end


local lifebloomUnit = player

function Resto:COMBAT_LOG_EVENT_UNFILTERED(event)
    local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()


    if(sourceGUID==player.guid)then
        --print("druid resto COMBAT_LOG_EVENT_UNFILTERED")
        --if (StringInGroupOfStrings(eventname,{"SPELL_AURA_APPLIED","SPELL_AURA_REMOVED"})then
        if (spellName == "Lifebloom") then
            if (eventname == "SPELL_AURA_APPLIED" or eventname == "SPELL_AURA_REFRESH") then
                if (groups.targetable[destGUID]) then
                    lifebloomUnit = groups.targetable[destGUID]
                    --[[lifebloom.unitid = groups.targetable[destGUID]
                    lifebloom.expires = select(7, UnitBuff(lifebloom.unitid, spellName)) or auras:GetDuration(spellName)]]
                else
                    --lifebloom.expires = GetTime() + auras:GetDuration(spellName)
                end
            elseif (eventname == "SPELL_AURA_REMOVED") then
                --lifebloom.expires = 0
            end

        end

    end
end

function Resto:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
    if unitid == "player" then
        local specId = GetSpecialization()
        if specId ~= 4 then
            frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else
            frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end
end
--Resto:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function player:IsLifebloomActive()
    if (lifebloomUnit:BuffRemaining("Lifebloom","HELPFUL|PLAYER") > 0) then
        return true
    --elseif (lifebloom.expires > GetTime()) then
    --    return true
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    Resto[event](self, event, ...); -- call one of the functions above
end)

for k, v in pairs(Resto) do
    frame:RegisterEvent(k);
end