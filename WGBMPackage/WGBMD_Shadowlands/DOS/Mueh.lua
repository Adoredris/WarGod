local WGBM = WarGod.BossMods

local bossString = "Mueh'zala"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Soulcrusher" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end

    local now = GetTime()
    local mechTime = 1337
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < mechTime and timeDiff > -10 then
            if strmatch(msg, "Soulcrusher") then
                mechTime = timeDiff
                if mechTime < 3 then
                    return true
                end
            end
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)


end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    return true
end