--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Sun King's Salvation"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    local score = 10
    if WarGod.Control:SafeMode() then
        if UnitIsUnit(unitid, "target") then
            return 10
        end
        return 0
    end
    if name == "Reborn Phoenix" then
        local boss1hpPercent = UnitExists("boss1") and WarGod.Unit:GetUnit("boss1").health_percent or 1
        local boss2hpPercent = UnitExists("boss2") and WarGod.Unit:GetUnit("boss2").health_percent or 1
        if unit.health_percent > 0.9 then
            return 0
        end
        local boss1hpPercent = UnitExists("boss1") and WarGod.Unit:GetUnit("boss1").health_percent or 1
        local boss2hpPercent = UnitExists("boss2") and WarGod.Unit:GetUnit("boss2").health_percent or 1
        if boss2hpPercent > 0.4 and boss2hpPercent < 0.47 then
            return 0
        end
    elseif name == "Soul Infuser" then
        score = 40
    elseif name == "Vile Occultist" then
        score = 30
    elseif name == "Shade of Kael'thas" then
        score = 20
    elseif name == "Rockbound Vanquisher" then
        score = 19

    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

--[[WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    --if 1==1 then return true end
    if name == "Soul Infuser" then
        return true
    --elseif name == "Rockbound Vanquisher" then
    --    return true
    --elseif name == "Bleakwing Assassin" then
    --    return true
    --elseif name == "Reborn Phoenix" then
    --    return true
    end
    return
end]]

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    -- temporary
    if name == "Kael'thas Sunstrider" then
        return true
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "High Torturer Darithos" then
        if not UnitIsUnit("target", unitid) then
            return true

        end
    end
    if name == "Reborn Phoenix" and unit.health_percent > 0.90 then
        return true
    end
    if WarGod.Unit:GetUnit("boss2"):BuffRemaining("Cloak of Flames", "HELPFUL") > 0 then
        if name == "Shade of Kael'thas" then
            return
        else
            return true
        end
    end

end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if DoingMythic() then
        if WarGod.Unit:GetUnit("boss2"):BuffRemaining("Cloak of Flames", "HELPFUL") > 0 then
            if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
                if WarGod.Rotation.rotationFrames["Balance"]["Celestial Alignment"]:CDRemaining() <= 0.5 then
                    return true, true
                end
            else
                return true, true
            end

        end

    else
        return true
    end
end

WGBM[bossString].BurstIn = function(spell, unit, args)
    local unitid = unit.unitid
    local burstIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff > -3 and timeDiff < burstIn then
            if strmatch(msg, "Cloak of Flames") then
                burstIn = timeDiff
            end
        end
    end
    return burstIn
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Shade of Kael'thas" then
        if unit:BuffRemaining("Cloak of Flames", "HELPFUL") > 0 then
            return true

        end
        local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff > -3 and timeDiff < 1 then
                if strmatch(msg, "Cloak of Flames") then
                    return true
                end
            end
        end
    end

    return false
end

WGBM[bossString].HealCD = function(spell, unit, args)
    --return WarGod.Unit:GetPlayer():TimeInCombat() < 10
    return true
end

--[[
WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end



WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Image of Absolution" then
        return true
    elseif WarGod.Control:SafeMode() then
        if UnitIsUnit("target", unitid) or UnitIsUnit("mouseover", unitid) then
            return
        else
            return true
        end
    elseif name == "Prophet Skitra" then
        if UnitHealthMax(unitid) > 100000000 then
            return
        else
            if UnitIsUnit("target", unitid) or UnitIsUnit("mouseover", unitid) then
                return
            else
                return true
            end
        end
    elseif name == "Shredded Psyche" then
        if UnitIsUnit("target", unitid) or UnitIsUnit("mouseover", unitid) then
            return
        else
            return true
        end
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
    if 1==1 then return true end
    return
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



]]