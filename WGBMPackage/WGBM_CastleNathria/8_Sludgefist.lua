--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Sludgefist"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    --if (CastTimeFor(spell) >= 1.5) then
    --if spell == "Starfire" then
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < moveIn and timeDiff > -5 then
            if strmatch(msg, "Falling Rubble") and timeDiff > -1 then
                moveIn = timeDiff
            elseif strmatch(msg, "Chain Slam") and WarGod.Unit:GetPlayer():BuffRemaining("Chain Link", "HARMFUL") > 0 then
                moveIn = timeDiff + 4
            elseif strmatch(msg, "Colossal Roar") and timeDiff > -1 then
                moveIn = timeDiff
            end
        end
    end

    --end
    return moveIn
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < 3 and timeDiff > -5 then
            if strmatch(msg, "Chain Slam") then
                if args[2] <= 60 then
                    return true
                end
            end
        end
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local now = GetTime()
    if WarGod.Unit:GetUnit("boss1"):BuffRemaining("Destructive Impact","HELPFUL") > 0 then
        return true
    end
    if WarGod.Unit:GetUnit("boss1").health_percent < 0.2 then
        return true
    end
    --[[for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < 1 then
            if strmatch(msg, "Destructive Impact") and args and args[1] and args[1] > 10 then
                return true
            end
        end
    end]]
end

WGBM[bossString].BurstIn = function(spell, unit, args)
    local unitid = unit.unitid
    local burstIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff > -10 and timeDiff < burstIn then
            if strmatch(msg, "Destructive Impact") then
                burstIn = timeDiff
            end
        end
    end
    return burstIn
end

WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < 3 and timeDiff > -10 then
            if strmatch(msg, "Destructive Impact") then
                return true
            end
        end
    end
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local remains = WarGod.Unit:GetUnit("boss1"):BuffRemaining("Destructive Impact","HELPFUL")
    if remains > 0 and remains < 4 then
        return true
    end

    return false
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if WarGod.Unit:GetPlayer().health_percent < 0.7 then
        return true
    end
    --end
    --return score, bossString
end

--[[

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
        return
    end
    local name = unit.name
    if name == "Blood of Ny'alotha" then
        if DoingMythic() and (not UnitIsUnit("target",unitid)) then
            return true
        else
            return
        end
    elseif name == "Il'gynoth" then
        return          -- probably need to check phasing
    elseif name == "Organ of Corruption" then
        if unit.health > 1 then
            return
        end
        return true
    else
        return
    end

    return false
end

WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    local name = unit.name
    if name == "Il'gynoth" then
        return true
    elseif name == "Organ of Corruption" then
        return true
    elseif name == "Blood of Corruption" then
        return true
    elseif name == "Clotted Corruption" then
        return true
    else
        return
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name ~= "Il'gynoth" then
        return true
    end
end


WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Blood of Ny'alotha" then
        if DoingMythic() and (not UnitIsUnit("target",unitid)) then
            score = 0
        elseif unit:DebuffRemaining("Mass Entanglement","HARMFUL") > 0 or unit:DebuffRemaining("Entangling Roots","HARMFUL") > 0 then

        else
            score = 10
        end
    --elseif name == "Pumping Blood" then   -- that's a spell that the organ's cast
    --    score = 10
    elseif name == "Organ of Corruption" then
        score = 10
    elseif name == "Il'gynoth" then

    elseif name == "Clotted Corruption" then
        score = 9
    else
        score = 15
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local haveEye = false
        for i=1,4 do
            local name = UnitDebuff("player", i)
            if name == "Eye of N'Zoth" then
                haveEye = true
            end
        end
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Eye of N'Zoth" then
            if haveEye then
                return UnitClass("player") ~= "Warrior", true, true
            end
            return UnitClass("player") ~= "Warrior", true
        end
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