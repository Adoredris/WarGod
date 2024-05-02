local WGBM = WarGod.BossMods

local bossString = "Gorechop"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Hateful Strike" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff > -1 and timeDiff < 3 then
            if strmatch(msg, "Hateful Strike") then
                return true
            end
        end
    end
    --return score, bossString
end