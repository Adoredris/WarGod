---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Flora.
--- DateTime: 15/08/2018 11:07 PM
---

local WGBM = WarGod.BossMods

local bossString = "The Darkness"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local name = unit.name
    if (unit:AuraRemaining("Seal Empowerment", "HELPFUL") > 0) then
        print('not dpsing with Seal Empowerment buff')
        return true
    end

    if name == "Incorporeal Being" then return true end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end
    return false
end

--[[WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Spirit of Gold") then
        return true
    end
end]]

WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    local silenceCastRemains = CastTimeRemaining("boss1", "Deafening Screech")
    local mySpellCastTime = WarGod.Rotation.CastTimeFor(spell)
    if mySpellCastTime == 0 or silenceCastRemains == 0 then return true end
    if silenceCastRemains > 0 then
        if silenceCastRemains > (args.buffer or 0.5) + mySpellCastTime then
            return true
        else
            print('not casting ' .. spell .. ' due to incoming interrupt')
        end
    end
end