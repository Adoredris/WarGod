local WGBM = WarGod.BossMods

local bossString = "Ingra Maloch"
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
    --end
    --return score, bossString
end]]

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Droman Oulfarran" then
        score = 20
    end
    if unit:BuffRemaining("Embrace Darkness", "HELPFUL") > 0 then
        return 1
    end
    --[[if UnitIsUnit(unitid, "target") then
        score = score + 5
    end]]


    return score, bossString
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (WarGod.Control:SafeMode()) then
        if not UnitIsUnit("target", unitid) then
            return true
        end
    end
    return
end