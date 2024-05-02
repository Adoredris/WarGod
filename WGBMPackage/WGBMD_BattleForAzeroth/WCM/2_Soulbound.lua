local WGBM = WarGod.BossMods

local bossString = "Soulbound Goliath"
printTo(3,bossString)
WGBM[bossString] = {}
-- this is more like a delegate
-- only really used for things that aren't flagged in combat
WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local unitname = unit.name
    if unitname == bossString then
        score = 10
    else
        score = 20
    end

    return score, bossString
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Soul Thorns") then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Crush" then
        return true
    end
    --end
    --return score, bossString
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -5 then
            if strmatch(msg, "Soul Thorns") then
                aoeIn = timeDiff
            end
        end
    end
    local spellName, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo("boss1")
    if spellName == "Soul Thorns" then
        aoeIn = ShouldEndAt / 1000 - now
    end
    return aoeIn

end