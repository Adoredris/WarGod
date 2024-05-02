local WGBM = WarGod.BossMods

local bossString = "Mordretha, the Endless Empress"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Reaping Scythe" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff > -1 and timeDiff < 2 then
            if strmatch(msg, "Reaping Scythe") then
                return true
            end
        end
    end
    --end
    --return score, bossString
end