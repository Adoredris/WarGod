local WGBM = WarGod.BossMods

local bossString = "Mists of Tirna Scithe"
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
    elseif (isBolstering) and isTank then
        return 10 + unit.health / WarGodBigNumber
    elseif haveBursting and isTank then
        if unit:BuffRemaining("Burst", "HARMFUL") > 0 then
            return 10 + unit.health / WarGodBigNumber
        else
            score = 10
            if UnitIsUnit(unitid, "target") then
                score = score + 5
            end
        end
    else
        score = 10
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
    end
    --[[if UnitIsUnit(unitid, "target") then
        score = score + 5
    end]]
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

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local cast = UnitCastingInfo(unitid) or UnitChannelInfo(unitid)
    if name == "Drust Boughbreaker" then
        return true     -- not sure if they cast interruptible
    elseif cast == "Bramblethorn Entanglement" then
        return
    elseif name == "Mistveil Defender" then
        return
    elseif name == "Mistveil Stalker" then
        return
    elseif name == "Mistveil Stinger" then
        return
    elseif name == "Mistveil Guardian" then
        return
    elseif name == "Mistveil Shaper" then
        if cast == "Bramblethorn Coat" then
            return true
        end
        return
    elseif name == "Mistveil Tender" then
        if cast == "Nourish the Forest" then
            return true
        end
        return
    elseif name == "Mistveil Nightblossom" then
        -- doesn't cast anything

    --[[elseif cast == "Wicked Bolt" then
        local boltTarget = UnitName(unitid .. "target")
        local health = UnitHealth(unitid .. "target")
        if health and health < 30000 then
            return true
        end
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if guid ~= UnitName(unitid) then
                if iterUnit.UnitCastingInfo(unitid .. "target") == "Wicked Bolt" then
                    return true
                end
            end
        end
        return]]
    end
    return true
end