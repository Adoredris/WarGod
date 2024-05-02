--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Artificer Xy'mox"      -- not right at all

WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end
    if name == bossString then
        if unit:BuffRemaining("Genesis Bulwark", "HELPFUL") > 0 then
            return true
        end
    end
end

--[[WGBM[bossString].Priority = function(spell, unit, args)
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
end]]