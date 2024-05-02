local WGBM = WarGod.BossMods

local bossString = "Halls of Atonement"
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
end]]

-- need to whitelist everything in the room before the last boss


WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local guid = unit.guid
    local cast = UnitCastingInfo(unitid) or UnitChannelInfo(unitid)
    local playerClass = UnitClass("player")
    if cast == "Siphon Life" then
        return
    elseif cast == "Curse of Obliteration" then
        if playerClass == "Druid" or playerClass == "Shaman" then
            return
        end
        return true
    elseif name == "Inquisitor Sigar" then
        return true
    elseif cast == "Wicked Bolt" then
        if playerClass == "Shaman" then return true end
        local health = UnitHealth(unitid .. "target")
        if health and health < 30000 then
            return true
        end

        for iterGuid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterGuid ~= guid then
                if UnitCastingInfo(iterUnit.unitid) == "Wicked Bolt" then
                    print('Interrupting Wicked Bolt cause 2 casting')
                    return true
                end
            end
        end
        return
    end
    return true
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if GetMinimapZoneText() == "The Sanctuary of Souls" then
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
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local haveBursting = affixes.bursting and WarGod.Unit:GetPlayer():DebuffRemaining("Bursting","HARMFUL") > 0
    local unitid = unit.unitid
    local isTank = UnitGroupRolesAssigned("player") == "TANK"
    local score = 10
    local name = unit.name
    if name == "Inquisitor Sigar" then
        score = 4
    elseif name == "Manifestation of Envy" then
        score = 1
    elseif name == "Tormented Soul" then
        score = 20
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
        score = 10
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
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

WGBM[bossString].StunUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Depraved Houndmaster" then
        if UnitCastingInfo(unitid) == "Loyal Beasts" then
            return true
        end
    end

    return false
end