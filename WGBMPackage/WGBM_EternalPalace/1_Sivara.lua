--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Abyssal Commander Sivara"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end]]

WGBM[bossString].Defensive = function(spell, unit, args)
    if WarGod.Unit:GetPlayer():DebuffRemaining("Overflowing Chill", "HARMFUL") > 0
            or WarGod.Unit:GetPlayer():DebuffRemaining("Overflowing Venom", "HARMFUL") > 0
            or WarGod.Unit:GetPlayer():DebuffRemaining("Unstable Mixture", "HARMFUL") > 0 then
        if args[2] <= 60 then
            return true
        elseif args[2] <= 120 and WarGod.Unit:GetPlayer().health_percent < 0.5 then
            return true
        end
    end
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    local theTime = GetTime()
    local spellName, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo("boss1")
    if spellName == "Crushing Reverberation" then
        moveIn = ShouldEndAt / 1000 - theTime
        return moveIn
    end
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now + 2
        if timeDiff < moveIn and timeDiff >= 0 then
            if strmatch(msg, "Crushing Reverberation") then
                moveIn = timeDiff
            end
        end
    end

    return moveIn
end

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

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if UnitGroupRolesAssigned("player") == "TANK" then
        return
    end
    if WarGod.Control:SafeMode() and not UnitIsUnit(unitid,"target") then
        return true
    end
    if strmatch(name, "Aspect") then
        if UnitIsUnit(unitid, "target") then
            return
        end
        local hpPercent = unit.health_percent
        local WarGodUnit = WarGod.Unit
        for i=1,2 do
            local bossUnitId = "boss" .. i
            local bossName = UnitName(bossUnitId)
            if not bossName then return end
            if bossName ~= name then
                if WarGodUnit[bossUnitId].health_percent < hpPercent then
                    return true
                end
            end
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if not strmatch(name, "Aspect") then
        if unit.health_percent < 0.2 then
            score = 12
        else
            score = 20
        end

    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score
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