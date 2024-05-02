

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Dausegne, the Fallen Oracle"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= "Dausegne") then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 10
    if name == "Domination Core" and unit.health_percent > 0.2 then
        score = 20
    end
    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Domination Core" then
        return true
    end

    return false
end