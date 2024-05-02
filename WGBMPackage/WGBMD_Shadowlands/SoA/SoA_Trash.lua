local WGBM = WarGod.BossMods

local bossString = "Spires of Ascension"
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
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local isTank = UnitGroupRolesAssigned("player") == "TANK"
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    --[[if (unit.name == "Explosives") then
        if UnitClass("player") == "Druid" then
            if spell == "Moonfire" or spell == "Sunfire" or GetSpecialization() == 2 then
                return 1000000, "default"
            else
                return
            end
        else
            return 1000000, "default"
        end
    else]]if unit.health_percent < 0.95 and unit:BuffRemaining("Inspiring Presence", "HELPFUL") > 0 then
        return 5000, "default"
    elseif (isBolstering) and isTank then
        score = 10 + unit.health / WarGodBigNumber
    else
        score = 10
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Forsworn Goliath" then
        if UnitCastingInfo(unitid) == "Rebellious Fist" then
            return true

        end
    elseif name == "Forsworn Castigator" then
        if UnitCastingInfo(unitid) == "Dark Lash" then
            return
        else
            return true     -- maybe (burden of knowledge
        end
    elseif name == "Forsworn Mender" then
        if UnitCastingInfo(unitid) == "Forsworn Doctrine" then      -- heal
            return true
        end
    elseif name == "Etherdiver" then        -- nasty dot crap
        return true

    elseif name == "Kyrian Dark-Praetor" then

    elseif name == "Forsworn Squad-Leader" then

    elseif name == "Forsworn Inquisitor" then

    elseif name == "Forsworn Warden" then
    end

    return true
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Forsworn Castigator" then
        return true
    elseif name == "Forsworn Goliath" then
        return true
    else--if name == "Unyielding Contender" or name == "Battlefield Ritualist" then
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Forsworn Castigator" or iterUnit.name == "Forsworn Goliath" then
                return
            end
        end
    end
    if UnitClassification(unitid) == "elite" then
        return true
    end
end

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
    if name == "Executioner Varruth" or name == "Soggodon the Breaker" or name == "Incinerator Arkolath" or name == "Oros Coldheart" then
        if (not UnitAffectingCombat(unitid)) then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local haveBursting = affixes.bursting and WarGod.Unit:GetPlayer():DebuffRemaining("Bursting","HARMFUL") > 0
    if GetRaidTargetIndex(unitid) == 8 then
        score = 50
    elseif name == "Forsworn Squad-Leader" then
        score = 40
    elseif name == "Forsworn Goliath" then
        score = 30
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    elseif name == "Lakesis" or name == "Astronos" or name == "Klotos" then
        score = 30 + unit.health_percent
    elseif (isBolstering or haveBursting) then
        score = 10 + unit.health / WarGodBigNumber
    else
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

WGBM[bossString].Cleanse = function(spell, unit, args)
    return true
end

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    local role = UnitGroupRolesAssigned(unitid)
    local score = 1
    if (role == "TANK") then
        score = 1
    elseif (role == "HEALER") then
        score = 2
    else
        score = 3
    end
    for i=1,40 do
        if UnitDebuff(unitid, i) then
            score = score + 1
        else
            return score
        end
    end
end