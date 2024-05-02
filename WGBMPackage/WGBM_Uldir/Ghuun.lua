--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
local bossString = "G'huun"      -- not right at all
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
        return args[2] <= 60
    end
    --return 1337
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local targetName = UnitName("target")
    if (name == "Gibbering Horror" and not UnitIsUnit(unitid, "target")) then
        return true
    elseif (name == "Amorphous Cyst" and targetName ~= name and targetName) then
        return true
    elseif name == "Dark Young" then
        return true
    elseif name == "G'huun" and (unit:BuffRemaining("Collapse", "HELPFUL") > 0 or unit:BuffRemaining("Corpulent Mass", "HELPFUL") > 0) then
        return true
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == bossString then
        if unit:BuffRemaining("Blood Shield","HELPFUL") > 0 and not UnitIsUnit("target", "boss1") then
            score = 0
        end
    elseif name == "Blightspreader Tendril" then
        score = 40
    elseif name == "Cyclopean Terror" then
        score = 30
    elseif name == "Dark Young" then
        score = 0
    --elseif name == "Gibbering Horror" then      -- p2
    --    score = 50
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    --[[local unitid = unit.unitid


    -- watch  "Gibbering Horror" cast of "Mind-Numbing Chatter"

    ]]
    return true
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    local targetName = UnitName("target")
    if unit.name == "G'huun" and unit.health_percent < 0.3 then
        return true
    elseif unit:DebuffRemaining("Reorigination Blast","HARMFUL") > 0 then
        return true
    elseif WarGodUnit:GetPlayer():DebuffRemaining("Dark Bargain", "HARMFUL") > 0 then
        return true
    elseif UnitIsUnit("target", "boss1") or targetName == "Gibbering Horror" then
        if unit:BuffRemaining("Blood Shield","HELPFUL") > 0 then
            return

        elseif unit:BuffRemaining("Corpulent Mass","HELPFUL") > 0 then      -- think there's a second one
            return
        elseif unit:DebuffRemaining("Reorigination Blast","HARMFUL") == 0 then
            if args and args[2] and args[2] > 90 then
                return
            else
                return true
            end
        end
        return true
    end
end