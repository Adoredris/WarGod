local WGBM = WarGod.BossMods

local bossString = "Kin-Tara"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Overhead Slash" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    if UnitExists("boss1target") then
        if UnitPower("boss1") > 95 then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Azules" then
        score = 20
    end
    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 5
    end
    return score, bossString
end