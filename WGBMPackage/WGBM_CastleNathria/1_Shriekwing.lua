--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Shriekwing"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if unit:BuffRemaining("Blood Shroud", "HELPFUL") > 0 then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        if UnitCastingInfo("boss1") == "Exsanguinating Bite" then
            return true

        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local now = GetTime()
    local cast = UnitCastingInfo(unit.unitid)
    if cast == "Earsplitting Shriek" then
        return
    elseif cast == "Blood Shroud" then
        return
    end
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if strmatch(msg, "Earsplitting Shriek") then
            if timeDiff < 20 and timeDiff > -1 then
                return args[1] < timeDiff
            end
        elseif strmatch(msg, "Blood Shroud") then
            if timeDiff < 20 and timeDiff > -1 then
                return args[1] < timeDiff
            end
        end
    end
    return true
end

--[[
WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
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
    if name == "Crackling Shard" and unit.health_percent > 0.5 then
        if UnitClass("player") == "Druid" and GetSpecialization() == 1 and WarGod.Unit:GetPlayer():Lunar_Power() >= 50 then
            return
        else
            return true
        end
    end
    return
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
    if (not args) or (not args[2]) then
        return true
    elseif args[2] > 30 then
        local now = GetTime()
        local intermissionIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            local intermissionIn = 1337
            if timeDiff < intermissionIn and timeDiff > -1 then
                if strmatch(msg, "Stage 2") then
                    intermissionIn = timeDiff
                elseif strmatch(msg, "^Burning Cataclysm") then
                    intermissionIn = timeDiff
                end
            end
        end
        return intermissionIn > 0.6 * args[2]
    end
    return true
end

]]