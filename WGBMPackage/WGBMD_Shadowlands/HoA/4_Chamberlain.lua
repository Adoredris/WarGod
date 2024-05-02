local WGBM = WarGod.BossMods

local bossString = "Lord Chamberlain"
printTo(3,bossString)
WGBM[bossString] = {}

--[[WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Hateful Strike" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
end]]

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid

    if args and args[2] <= 60 and unit:BuffRemaining("Ritual of Woe", "HARMFUL") > 0 then
        return true
    end
end