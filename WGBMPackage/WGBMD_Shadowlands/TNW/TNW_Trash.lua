local WGBM = WarGod.BossMods

local bossString = "The Necrotic Wake"
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
    elseif name == "Skeletal Marauder" then
        if unit:BuffRemaining("Boneshatter Shield","HELPFUL") > 0 then
            score = 20
        end
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
    if name == "Brittlebone Mage" then
        return true
    elseif name == "Brittlebone Warrior" then
        return true
    elseif name == "Brittlebone Crossbowman" then
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
    local targetName = unit.name

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

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local casting = UnitCastingInfo(unitid)
    local channel = UnitChannelInfo(unitid)
    if unit.name == "Zolramus Sorceror" then
        return true
    elseif casting == "Frostbolt Volley" then
        return true
    end
    return true
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Skeletal Marauder" then
        return true
    elseif name == "Nar'zudah" then
        return true
    elseif name == "Corpse Harvester" then
        return true
    elseif name == "Stitched Vanguard" then
        local seethingStacks = unit:BuffStacks("Seething Rage", "HELPFUL")
        if seethingStacks == 0 or seethingStacks >= 8 then  -- stacks == 0 means that the enrage affix is up
            return true
        end
        return
    elseif name == "Fleshcrafter" then
        return true
    elseif name == "Zolramus Gatekeeper" then   -- not supposed to pull these but anyway
        return true
    elseif name == "Zolramus Bonecarver" then
        return true
    elseif name == "Zolramus Sorcerer" then
        return true
    elseif name == "Zolramus Bonemender" then
        return true
    elseif name == "Zolramus Necromancer" then
        return true
    elseif name == "Loyal Creation" then
        return true
    elseif name == "Corpse Collector" then
        return true
    elseif name == "Corpse Collector" then
        return true
    elseif name == "Stitching Assistant" then
        return true
    elseif name == "Separation Assistant" then
        return true
    elseif name == "Patchwerk Soldier" then
        for guid,iterUnit in WarGod.Unit.upairs(WarGod.Unit.groups.targetable) do
            local name = iterUnit.name
            if name ~= "" and iterUnit.name ~= "Patchwerk Soldier" then
                if iterUnit.health_percent < 0.25 then
                    if unit:BuffRemaining("Raging","HARMFUL") > 0 then
                        return
                    end
                elseif iterUnit.health_percent < 0.6 then
                    return
                end
            end
            return true
        end
    --[[else--if name == "Unyielding Contender" or name == "Battlefield Ritualist" then
        for guid,iterUnit in upairs(WarGod.Unit.groups.harmOrPlates) do
            if iterUnit.name == "Forsworn Castigator" or iterUnit.name == "Forsworn Goliath" then
                return
            end
        end]]
    end
    if UnitClassification(unitid) == "elite" then
        return true
    end
end