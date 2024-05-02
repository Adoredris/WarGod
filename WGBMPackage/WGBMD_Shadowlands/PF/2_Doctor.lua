local WGBM = WarGod.BossMods

local bossString = "Doctor Ickus"
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

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    local score = 10

    if name == "Erupting Ooze" then
        score = 0
    elseif name == "Plague Bomb" then
        score = 40
    elseif name == "Congealed Slime" then
        if UnitName("target") == "Plague Bomb" then
            score = 0
        else
            score = 10
        end
    elseif name == "Doctor Ickus" then
        if unit:BuffRemaining("Congealed Contagion", "HARMFUL") > 0 then
            score = 1
        else
            score = 20
        end
    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score, bossString
end