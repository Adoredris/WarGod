---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Flora.
--- DateTime: 15/08/2018 11:07 PM
---

local WGBM = WarGod.BossMods

local bossString = "Merektha"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Dust Cloud", "HARMFUL") > 0) then
        printTo(3,'not dpsing while obscured buff')
        return true
    end

    return false
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -10 then
            if strmatch(msg, "Hatch") then
                aoeIn = timeDiff + 5
            end
        end
    end
    return aoeIn

end