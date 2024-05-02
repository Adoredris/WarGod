local WGBM = WarGod.BossMods

local bossString = "Surgeon Stitchflesh"
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
    local score = 10
    local name = unit.name
    if name == "Surgeon Stitchflesh" then
        score = 30
    else
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    return true
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit("target",unit.unitid) then
            return true
        end
    end
    if unit:BuffRemaining("Noxious Fog","HELPFUL") > 0 then
        return true
    end
end