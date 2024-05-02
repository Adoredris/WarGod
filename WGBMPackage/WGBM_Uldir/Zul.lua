--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Zul, Reborn"      -- not right at all
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

--[[WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Ravenous Blaze", "player", nil, true) > 0) then
        return 60
    end
    return 1337
end]]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Minion of Zul" and UnitName("target") ~= "Minion of Zul") then
        return true
    elseif (name == "Nazmani Bloodhexer"  and not UnitIsUnit("target", unitid) and UnitDebuff(unitid, 10) == nil) then       -- 5 debuffs, probably dotted
        return true
    else--[[if name == "Ember of Taeshalach" then
        if not DoingNormMax() then
            if DoingMythic() then
                if WarGodCore:AOEMode() then
                    return false
                end
            else
                return true
            end
        end]]
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
    if name == "Galecaller Faye" then
        score = 15
    elseif name == "Brother Ironhull" then
        score = 14
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Purge = function(spell, unit, args)
    if UnitClass("player") == "Mage" then
        return

    end
    return true
end