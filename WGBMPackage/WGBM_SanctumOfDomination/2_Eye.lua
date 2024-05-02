--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Eye of the Jailer"      -- not right at all
WGBM[bossString] = {}
local altName = "Eye of the Jailer"
WGBM[altName] = WGBM[bossString]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Eye of the Jailer" then
        score = 10
    elseif name == "Stygian Abductor" then
        if spell == "Fury of Elune" and WarGod.Unit:GetPlayer().buff.ravenous_frenzy:Up() then
        else
            if unit.health_percent > 0.05 then
                score = 30
            end
        end
    elseif name == "Deathseeker Eye" then
        score = 30
    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitName("target") == "Deathseeker Eye" then
        if WarGod.Unit.boss1.health_percent < 0.35 then
            if args[2] >= 120 then
                return
            end
        end
        return true
    end
    if WarGod.Unit.boss1.health_percent < 0.68 and WarGod.Unit.boss1.health_percent > 0.66 then
        return
    end
    if WarGod.Unit.boss1.health_percent < 0.35 and WarGod.Unit.boss1.health_percent > 0.33 then
        return
    end
    return true
    --if WarGod.Unit.boss1.health_percent < 0.68 and WarGod. then

    --end
end

--[[WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitName("target") == "Deathseeker Eye" then
        if WarGod.Unit.boss1.health_percent < 0.35 then
            if args[2] >= 120 then
                return
            end
        end
        return true
    end
end]]

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Deathlink" then
            return true
        end
    end
end

--[[WGBM[bossString].HealCD = function(spell, unit, args)
    local a = WarGod.Unit:GetPlayer():TimeInCombat()
end]]


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
end



WGBM[bossString].FriendlyPriority = function(spell, unit, args)
    if unit:BuffRemaining("Bwonsamdi's Wrath", "HARMFUL") > 0 and spell ~= "Remove Corruption" then
        return 0
    else
        return 10 - unit.health_percent
    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:BuffRemaining("Crawling Hex", "HARMFUL") > 0 then
        return
    end
    if UnitGroupRolesAssigned(unitid) == "TANK" then
        return true
    elseif unit.health_percent < 0.4 then
        return true
    elseif WGBM:TimeSinceLastDamagedBy("Pa'ku's Wrath") < 1 then
        return true
    elseif unit:DebuffRemaining("Kimbul's Wrath", "HARMFUL") > 0 then
        return true
    elseif unit:DebuffRemaining("Akunda's Wrath", "HARMFUL") > 0 then
        return true
    end
    if unit:DebuffRemaining("Mind Wipe", "HARMFUL") > 0 then
        return true
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