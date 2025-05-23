---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Flora.
--- DateTime: 15/08/2018 11:07 PM
---

local WGBM = WarGod.BossMods

local bossString = "Raal the Gluttonous"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid


    return false
end

--[[WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local unitname = unit.name
    if not UnitIsUnit(unitid, "boss1") and not UnitIsUnit(unitid, "boss2") and not UnitIsUnit(unitid, "boss3") then
        score = 20
    end

    return score, bossString
end]]

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Wasting Servant") then
        return true
    elseif (name == "Bile Oozeling") then
        return true
    end
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -2 then
            if strmatch(msg, "Rotten Expulsion") then
                aoeIn = timeDiff + 5
            end
        end
    end
    local spellName, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo("boss1")
    if spellName == "Rotten Expulsion" then
        aoeIn = ShouldEndAt / 1000 - now + 4
    end
    return aoeIn

end