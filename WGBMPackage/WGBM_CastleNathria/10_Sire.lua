--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Sire Denathrius"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].Defensive = function(spell, unit, args)
    local player = WarGod.Unit:GetPlayer()
    if player:DebuffRemaining("Feeding Time", "HARMFUL") > 0 or player:DebuffRemaining("Carnage", "HARMFUL") > 0 or player:DebuffRemaining("Crimson Chorus", "HARMFUL") > 0 then
        if args[2] <= 60 then
            return true
        elseif args[2] <= 120 then
            return WarGod.Unit:GetPlayer().health_percent < 0.7
        end
    end
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Echo of Sin" and UnitIsUnit(unitid, "target") then
        return true
    end

    --return false
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10

    if name == "Remornia" then
        score = 1
    elseif name == "Crimson Cabalist" then
        score = 20
    end

    if (UnitIsUnit("target", unitid))  then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name

    if WarGod.Control:SafeMode() then
        if (UnitIsUnit("target", unitid)) then
            return
        end
        return true
    end
    if name == "Remornia" and WarGod.Unit:GetUnit("boss1").health_percent < 0.4 then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossThreat = UnitThreatSituation("player","boss1")
    local bossCasting = UnitCastingInfo("boss1") or UnitChannelInfo("boss1")
    if bossThreat and bossThreat >= 3 then
        if bossCasting == "Shattering Pain" then
            return true
        end
    end
end
