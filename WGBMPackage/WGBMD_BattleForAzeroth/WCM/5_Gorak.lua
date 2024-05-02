local WGBM = WarGod.BossMods

local bossString = "Gorak Tul"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -2 then
            if strmatch(msg, "Summon Deathtouched Slaver") then
                aoeIn = timeDiff + 0.5
            end
        end
    end
    local spellName, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo("boss1")
    if spellName == "Summon Deathtouched Slaver" then
        aoeIn = ShouldEndAt / 1000 - now + 0.5
    end
    return aoeIn

end