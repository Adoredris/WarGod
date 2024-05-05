local WGBM = WarGod.BossMods

local bossString = "Theater of Pain"
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
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
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
    elseif (isBolstering or haveBursting) and isTank then
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

WGBM[bossString].Mitigation = function(spell, unit, args)
    local name = unit.name
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1") or UnitChannelInfo("boss1")
    if name == "Dokigg the Brutalizer" then
        if bossCasting == "Savage Flurry" then
            local bossThreat = UnitThreatSituation("player","boss1")
            if not bossThreat or bossThreat < 3 then
                return true
            end
        end
    end
    --return score, bossString
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitCastingInfo(unitid) == "Bone Spike" then
        return
    end
    return true
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