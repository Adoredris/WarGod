

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Vigilant Guardian"
WGBM[bossString] = {}

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 5
    if name == "Pre-Fabricated Sentry" and unit.health_percent > 0.1 then
        score = 30
    elseif name == "Automated Defense Matrix" then
        score = 20
    elseif name == "Volatile Materium" then
        if spell == "Sunfire" then
            score = 0
        elseif spell == "Moonfire" and unit.health_percent < 0.7 then
            score = 0
        elseif unit.health_percent > 0.1 then
            score = 15
        end
    elseif name == "Point Defense Drone" then
        if spell == "Sunfire" then
            score = 0
        elseif spell == "Moonfire" and unit.health_percent < 0.7 then
            score = 0
        elseif unit.health_percent > 0.1 then
            score = 15
        end
    elseif name ~= bossString and unit.health_percent > 0.1 then
        score = 15
    end

    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 2
    end
    if unit:BuffRemaining("Force Field","HELPFUL") > 0 then
        score = score * 0.1
    end
    return score, bossString
end

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