local WGBM = WarGod.BossMods

local bossString = "Grand Proctor Beryllia"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1") or UnitChannelInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Iron Spikes" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    return true
end