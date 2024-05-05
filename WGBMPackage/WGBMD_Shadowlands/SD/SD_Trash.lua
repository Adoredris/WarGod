local WGBM = WarGod.BossMods

local bossString = "Sanguine Depths"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
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
        score = 5000
    elseif (isBolstering or haveBursting) and isTank then
        score = 10 + unit.health / WarGodBigNumber
    else
        if name == "Grand Overseer" then
            score = 40
        end
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    end

    return score, bossString
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    if name == "Animated Weapon" then
        return true
    end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    elseif name == "General Kaal" then
        if UnitAffectingCombat(unit.unitid) == true then
            return
        else
            return true
        end
    end
    if name == "Executioner Varruth" or name == "Soggodon the Breaker" or name == "Incinerator Arkolath" or name == "Oros Coldheart" then
        if (not UnitAffectingCombat(unitid)) then
            return true
        end
    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    return true
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Stonewall Gargon" then
        return
    elseif name == "Grubby Dirtcruncher" then
        return unit:BuffRemaining("Motivated","HELPFUL") > 0
    elseif name == "Famished Tick" then
        return
    elseif name == "Frenzied Ghoul" then
        return unit:BuffRemaining("Frenzy","HELPFUL") > 0
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

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local casting = UnitCastingInfo(unitid)
    local channel = UnitChannelInfo(unitid)
    if (not UnitExists("focus")) or UnitIsUnit("focus", unitid) or UnitIsDead("focus") or UnitIsPlayer("focus") then
        if name == "Wicked Oppressor" then
            if casting == "Curse of Suppression" then
                local targetUnitId = unitid.."target"
                if UnitIsUnit("player", targetUnitId) then
                    return true
                elseif UnitGroupRolesAssigned(targetUnitId) == "HEALER" then
                    local playerClass = UnitClass("player")
                    if playerClass == "Druid" or playerClass == "Mage" or playerClass == "Shaman" then
                        return
                    else
                        return true
                    end
                end

            else
                return true
            end
        elseif name == "Grand Overseer" then
            return
        else
            return true
        end
    end
end