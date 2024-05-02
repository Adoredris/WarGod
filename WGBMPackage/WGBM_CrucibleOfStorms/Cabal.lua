--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Restless Cabal"      -- not right at all
WGBM[bossString] = {}
--local altName = "Conclave of the Chosen"
--WGBM[altName] = WGBM[bossString]


--[[
WGBM[bossString].HealCD = function(spell, unit, args)
    if WGBM:TimeSinceLastDamagedBy("Pa'ku's Wrath") < 2 then
        return true
    end
end

WGBM[bossString].Defensive = function(spell, unit, args)
    if WGBM:TimeSinceLastDamagedBy("Pa'ku's Wrath") < 2 then
        if args[2] <= 60 then
            return true
        elseif args[2] <= 120 and WarGod.Unit:GetPlayer().health_percent < 0.5 then
            return true
        end
    end
end]]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end
    if unit.name == "Eldritch Abomination" then
        return true
    end
    if  UnitIsUnit(unitid, "target") then
        return
    end
    if  unit.name == "Fa'thuul the Feared" then
        return
    elseif unit.name == "Zaxasj the Speaker" then
        if WarGod.Unit:GetPlayer():TimeInCombat() > 10 then
            return
        end
    elseif unit.name == "Visage from Beyond" then
        if unit.health_percent > 0.02 then
            return
        end
    end
    return true
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    -- only interrupt if you have the debuff thingy on you (thinking priority is to not get multiple stacks, rather than to avoid them entirely
    if UnitIsUnit(unit.unitid, "target") then
        return true

    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    return
end
--[[
WGBM[bossString].FriendlyPriority = function(spell, unit, args)
    if unit:BuffRemaining("Bwonsamdi's Wrath", "HARMFUL") > 0 and spell ~= "Remove Corruption" then
        return 0
    else
        return 10 - unit.health_percent
    end
end



WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:BuffRemaining("Crawling Hex", "HARMFUL") > 0 then
        return 0
    end
    if UnitGroupRolesAssigned(unitid) == "TANK" then
        return 2
    elseif UnitIsUnit("player",unitid) then
        return 1.9
    else
        return 1.5 - unit.health_percent

    end
end
]]