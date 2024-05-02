local WGBM = WarGod.BossMods

local bossString = "Blightbone"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Crunch" then
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

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name ~= bossString then return true end
    return
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit("target",unit.unitid) then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local haveBursting = affixes.bursting and WarGod.Unit:GetPlayer():DebuffRemaining("Bursting","HARMFUL") > 0
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if (not WarGod.Control:SafeMode()) and name ~= bossString then
        if spell ~= "Fury of Elune" then
            if unit.health_percent > 0.5 then
                score = 20 + unit.health_percent
            end
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end