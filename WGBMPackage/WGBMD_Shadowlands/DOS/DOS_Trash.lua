local WGBM = WarGod.BossMods

local bossString = "De Other Side"
printTo(3,bossString)
WGBM[bossString] = {}


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
    elseif name == "Experimental Sludge" then
        return true
    elseif name == "Atal'ai Devoted" then
        if UnitChannelInfo(unitid) == nil and UnitCastingInfo(unitid) == nil then
            return true
        end
    elseif name == "Atal'ai Deathwalker's Spirit" then
        return true
    elseif name == "Spiteful Shade" and UnitName("target") ~= "Spiteful Shade" then
        return true
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
    if GetRaidTargetIndex(unitid) == 8 then
        score = 20
    elseif name == "Atal'ai Devoted" then
        score = 70 + unit.health_percent
    elseif name == "Son of Hakkar" then     -- is this what they called?
        score = 50
    --[[elseif (unit.name == "Explosives") then
        if UnitClass("player") == "Druid" then
            if spell == "Moonfire" or spell == "Sunfire" or GetSpecialization() == 2 then
                return 1000000, "default"
            else
                return
            end
        else
            return 1000000, "default"
        end]]
    elseif unit.health_percent < 0.95 and unit:BuffRemaining("Inspiring Presence", "HELPFUL") > 0 then
        return 5000, "default"
    elseif (isBolstering or haveBursting) and isTank then
        return 10 + unit.health / WarGodBigNumber
    else
        if name == "Enraged Spirit" then
            score = 40 + unit.health_percent
        elseif name == "Atal'ai Deathwalker" then
            score = 20 + unit.health_percent
        elseif name == "Bladebeak Matriarch" then
            score = 50 + unit.health_percent
        elseif name == "Bladebeak Hatchling" then
            score = 40 + unit.health_percent
        elseif name == "Spiteful Shade" then
            score = 1
        end
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    end
    return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local cast = UnitCastingInfo(unitid)
    if name == "Risen Cultist" then
        return
    elseif name == "Incinerator Arkolath" then
        return true
    elseif cast == "Smite" then
        return
    elseif cast == "Frostbolt" then
        return
    elseif cast == "Hex" then
        if UnitClass(unitid .. "target") == "Druid" and UnitGroupRolesAssigned(unitid .. "target") ~= "HEALER" then
            return
        end
        return true
    elseif cast == "Lightning Discharge" then
        return
    else
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Incinerator Arkolath" then
                return
            end
        end
    end

    return true
end



--[[WGBM[bossString].Purge = function(spell, unit, args)
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
end]]

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

WGBM[bossString].AoeBlacklisted = function(spell, unit, args)
    local name = unit.name
    if name == "Explosives" then
        return true
    elseif name == "Enraged Mask" then
        return true
    end
end