local WGBM = WarGod.BossMods
local bossString = "Lady Inerva Darkvein"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Taunt = function(spell, unit, args)
    local unitid = unit.unitid
    if unit.name == bossString then

        if WarGod.Rotation.Delegates:IAmTankingUnit(spell, unit, args) then return end

        local playerRemains, playerStacks = WarGod.Unit:GetPlayer():BuffRemaining("Warped Desires", "HARMFUL")
        if playerStacks == 0 then
            for guid,unit in upairs(WarGod.Unit.groups.help) do


            end
            print("Should Taunt now - debug")
            return true
        end
    end
end]]

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= bossString) then
            return 0
        end
    end

    if name ~= bossString then
        score = 20
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local haveCrush = false
        local haveDissolve = false
        for i=1,4 do
            local name = UnitDebuff("player", i)
            if name == "Dissolve" then
                haveDissolve = true
            elseif name == "Crush" then
                haveCrush = true
            end
        end
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Dissolve" then
            if haveCrush then
                return
            end
            return UnitClass("player") ~= "Warrior", true
        end
        if bossCasting == "Crush" then
            if haveDissolve then
                return
            end
            return true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            return
        end
        if debuffName == "Shared Cognition" then
            if args[2] <= 150 then
                return true
            end
        end
    end
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    local addsIn = 1337
    if name ~= bossString then
        --if spell == "Sunfire" or spell == "Moonfire" and WarGod.Unit:GetPlayer().talent.twin_moons.enabled then
            return unit.health_percent < 0.4
        --end
    end
    return
end


WGBM[bossString].Interrupt = function(spell, unit, args)
    if GetRaidTargetIndex(unit.unitid) == 7 then
        return true
    end
    return
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    return
end

--[[
WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if 1==1 then return true end
    return
end




WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    local combatTime = WarGod.Unit:GetPlayer():TimeInCombat()
    if WarGod.Unit:GetUnit("boss1").health_percent < 0.65 then
        return
    end
end




WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= bossString) then
            return 0
        end
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        return true
    end
    --end
    --return score, bossString
end

WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    if spell == "Primal Wrath" then
        if WarGod.Unit.active_enemies >= 4 then
            local numEnemies = 0
            for guid,unit in upairs(groups.harmOrPlates) do
                if Delegates:HarmIn10Yards("Rake", unit, {}) then
                    numEnemies = numEnemies + 1
                end
                if numEnemies >= 4 then
                    return true
                end
            end
        end
        return
    end
    if unit.name == "Zoatroid" then
        if UnitClass("player") == "Druid" then
            if GetSpecialization() == 1 then
                if spell ~= "Sunfire" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    return
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 then
                    return
                end
            end
        elseif UnitClass("player") == "Priest" then
            if WarGod.Unit:GetPlayer().talent.misery.enabled and spell == "Shadow Word: Pain" and (not IsMoving()) then
                return

            end
        end
    end
    return true
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if WarGod.Unit:GetPlayer():DebuffRemaining("Incubation Fluid", "HARMFUL") > 0 then
        if (CastTimeFor(spell) >= 1.5) then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < moveIn and timeDiff > -1 then
                    if strmatch(msg, "Arcing Current") then
                        moveIn = timeDiff
                    end
                end
            end

        end
    end
    return moveIn
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end

]]