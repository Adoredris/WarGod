---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Flora.
--- DateTime: 15/08/2018 11:07 PM
---

local WGBM = WarGod.BossMods

local bossString = "Waxface"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    local name = unit.name
    local unitid = unit.unitid
    if (UnitAffectingCombat(unitid)) then
        return
    end
    if UnitIsUnit("target",unitid) then return end
    if UnitIsUnit("mouseover",unitid) then return end

    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end
    return true
end

--[[WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Spirit of Gold") then
        return true
    end
end]]

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 20
    local name = unit.name
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local name = unit.name

    return true
end