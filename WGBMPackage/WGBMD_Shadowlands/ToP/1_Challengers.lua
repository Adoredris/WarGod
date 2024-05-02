local WGBM = WarGod.BossMods

local bossString = "An Affront of Challengers"
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
    local unitid = unit.unitid
    local name = unit.name
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
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    --[[if (name == "Explosives") then
        if UnitClass("player") == "Druid" then
            if spell == "Moonfire" or spell == "Sunfire" or GetSpecialization() == 2 then
                return 1000000, bossString
            else
                return
            end
        else
            return 1000000, bossString
        end
    --elseif unit:BuffRemaining("Congealed Contagion", "HELPFUL") > 0 then
    --    return 1, bossString
    else]]if unit.health_percent < 0.95 and unit:BuffRemaining("Inspiring Presence", "HELPFUL") > 0 then
        return 5000, bossString
    elseif name == "Dessia the Decapitator" then
            score = 40
    elseif name == "Paceran the Virulent" then
        score = 20
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    elseif name == "Sathel the Accursed" then
        score = 24
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    else
        if UnitIsUnit(unitid, "target") then
            score = 50
        end
    end
    return score, bossString
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Raging Bloodhorn" then
        return true
    elseif name == "Unyielding Contender" or name == "Battlefield Ritualist" then
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Raging Bloodhorn" then
                return
            end
        end
    end
    return true
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitid = unit.unitid
    if WarGod.Unit.active_enemies >= 3 then
        return true
    end
    if args[2] >= 180 then
        local totalPercent = 0
        for k,unit in upairs(WarGod.Unit.groups.harmOrPlates) do
            totalPercent = totalPercent + unit.health_percent
        end
        return totalPercent >= 0.8
    end
    --[[if WarGod.Unit.boss1.health_percent < 0.68 and WarGod.Unit.boss1.health_percent > 0.66 then
        return
    end
    if WarGod.Unit.boss1.health_percent < 0.35 and WarGod.Unit.boss1.health_percent > 0.33 then
        return
    end
    return true]]
    --if WarGod.Unit.boss1.health_percent < 0.68 and WarGod. then

    --end
end