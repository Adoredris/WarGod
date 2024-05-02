--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "N'Zoth the Corruptor"      -- not right at all
WGBM[bossString] = {}

--local CanPersonallySeeUnit = CanPersonallySeeUnit

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name ~= "Psychophage" then
        return true
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("N'Zoth Blacklist")
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) and (not UnitIsUnit(unitid, "mouseover")) then
            return true
        end
    --[[elseif WarGod.Unit.boss1:BuffRemaining("Psychic Shell", "HELPFUL") == 0 then
        if name ~= "N'Zoth the Corruptor" and name ~= "Basher Tentacle" then
            return true
        end]]
    elseif name == "Psychophage" then
        if CanPersonallySeeUnit(unit) or WarGod.Unit.boss1:BuffRemaining("Psychic Shell", "HELPFUL") == 0 then
            return
        else
            return true
        end
    elseif name == "Thought Harvester" then
        return
    else
        if name == "N'Zoth the Corruptor" then
            if unit:BuffRemaining("Psychic Shell", "HELPFUL") > 0 and UnitClass("player") ~= "Hunter" then
                return true
            end
        else
            local mouseoverName = UnitName("mouseover")
            local targetName = UnitName("target")
            if mouseoverName == "Psychus" or targetName == "Psychus" or mouseoverName == "Exposed Synapse" or targetName == "Exposed Synapse" then
                if name == "Psychus"then
                    return
                elseif name == "Exposed Synapse" and (UnitIsUnit("mouseover", unitid) or UnitIsUnit("target", unitid)) then
                    return
                else
                    return true
                end

            end
        end

        --[[if UnitIsUnit(unitid, "target") or UnitIsUnit(unitid, "mouseover") then
            return
        else
            return true
        end]]
    end
end

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if not UnitInPhase(unitid) then
        return true
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
    --if 1==1 then return true end
    if name == "Basher Tentacle" or name == "Corruptor Tentacle" or name == "Spike Tentacle" then
        return true
    end
    return
end


WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid


    local name = unit.name
    local score = 10
    --[[if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= bossString) then
            return 0
        end
    end]]

    --[[if name == "Basher Tentacle" then
        score = 30
    elseif name == "N'Zoth the Corruptor" then
        if unit:BuffRemaining("Psychic Shell", "HELPFUL") == 0 then
            score = 40
        end
    end]]


    if name == "N'Zoth the Corruptor" then
        if unit:BuffRemaining("Psychic Shell", "HELPFUL") > 0 then
            if spell == "Barbed Shot" then
                score = 1
            else
                score = 0
            end
        end

    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local combatTime = WarGod.Unit:GetPlayer():TimeInCombat()
    if args[2] > 60 and (not DoingMythic()) then
        if combatTime > 30 and UnitName("target") == "N'Zoth the Corruptor" then
            return true
        elseif combatTime > 180 then
            return true
        end
    else
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitChannelInfo("boss1")
        if bossCasting == "Void Lash" then
            return UnitClass("player") ~= "Warrior", true, true
        end
    end
    --end
    --return score, bossString
end

--[[
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
]]
--[[
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