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
        return 10 + unit.health / WarGodBigNumber
    else
        score = 10
        if UnitIsUnit(unitid, "target") then
            score = score + 5
        end
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
    local casting = UnitCastingInfo(unitid)
    local channel = UnitChannelInfo(unitid)
    if casting == "Withering Discharge" then
        return true
    elseif casting == "Inferno" then    -- season 2 idiot
        return true
    elseif channel == "Bind Soul" then
        return true
    elseif casting == "Bone Spear" then
        return true     -- not sure about this one
    elseif casting == "Necrotic Bolt Volley" then
        return true
    elseif casting == "Meat Shield" or channel == "Meat Shield" then
        -- not sure how much I care about this one
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Raging Bloodhorn" then
                return
            end
        end
        return true
    elseif casting == "Battle Trance" then
        return true
    end
    --[[if UnitCastingInfo(unitid) == "Bone Spike" then
        return
    end]]
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
    if UnitClassification(unitid) == "elite" then
        return true
    end
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

WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    if WarGod.Control:SafeMode() then
        return true
    end
    local unitid = unit.unitid
    local castTime = CastTimeFor(spell)
    local remains = unit:AuraRemaining("Quake", "HARMFUL")
    for k,v in upairs(WarGod.Unit.groups.harmOrPlates) do
        local roarRemains = CastTimeRemaining(v.unitid, "Interrupting Roar")
        if roarRemains > 0 then
            print(roarRemains)
            if remains > 0 then
                remains = min(roarRemains, remains)
            else
                remains = roarRemains
            end
            break
        end
    end
    --print(spell)
    if remains > 0 then
        if castTime == 0 then
            if WarGod.Unit:GetPlayer().channels then
                local channels = WarGod.Unit:GetPlayer().channels
                if channels[spell] then
                    if channels[spell] - 0.25 > remains then
                        return
                    end
                end
            end
        else
            --print((castTime + 0.5) .. " > " .. remains)
            if castTime + 0.5 > remains then
                return
            end

        end
    end
    return true
end