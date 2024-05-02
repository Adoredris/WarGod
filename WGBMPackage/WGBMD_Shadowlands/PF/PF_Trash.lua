local WGBM = WarGod.BossMods

local bossString = "Plaguefall"
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
    elseif name == "Slime Tentacle" or name == "Defender of Many Eyes"  then
        if UnitAffectingCombat(unit.unitid) == true then
            return
        else
            return true
        end
    elseif name == "Rigger Plagueborer" then
        return UnitIsUnit(unitid)
    end
    if name == "Executioner Varruth" or name == "Soggodon the Breaker" or name == "Incinerator Arkolath" or name == "Oros Coldheart" then
        if (not UnitAffectingCombat(unitid)) then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local haveBursting = affixes.bursting and WarGod.Unit:GetPlayer():DebuffRemaining("Bursting","HARMFUL") > 0
    local isTank = UnitGroupRolesAssigned("player") == "TANK"
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
    else]]if unit:BuffRemaining("Congealed Contagion", "HARMFUL") > 0 then
        return 1, bossString
    elseif unit.health_percent < 0.95 and unit:BuffRemaining("Inspiring Presence", "HELPFUL") > 0 then
        return 5000, bossString
    elseif (isBolstering or haveBursting) and isTank then
        score = 10 + unit.health / WarGodBigNumber
    else
        score = 10
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    end
    return score, bossString
end

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraStacks("Necrotic", "HELPFUL") > 49) then
        return true
    elseif unit:BuffRemaining("Forgeborne Reveries", "HELPFUL") > 0 then
        return true
    end

    return
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --[[if name == "Raging Bloodhorn" then
        return true
    elseif name == "Unyielding Contender" or name == "Battlefield Ritualist" then
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Raging Bloodhorn" then
                return
            end
        end
    end]]
    if UnitClassification(unitid) == "elite" then
        return true
    end
end

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    local role = UnitGroupRolesAssigned(unitid)
    local score = 1
    if (role == "TANK") then
        score = 1
    elseif (role == "HEALER") then
        score = 5
    else
        score = 4
    end
    for i=1,40 do
        local debuffName, id, stacks = UnitDebuff(unitid,i)
        if debuffName then
            if stacks == 0 or (not stacks) then stacks = 1 end
            score = score + stacks
        else
            return score
        end
    end
    return score
end