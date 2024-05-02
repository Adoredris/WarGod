

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Anduin Wrynn"
WGBM[bossString] = {}

local explosionName = "Necrotic Detonation"
local count = 0

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end

    if name == bossString then
        if unit:BuffRemaining("Domination's Grasp", "HELPFUL") > 0 then
            return true
        end
    end
    if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    end
    if name == "Grim Reflection"  then
        return unit.health_percent > 0.95 and (not UnitIsUnit("target", unitid))
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    --[[if name == "Grim Reflection" then
        return unit.health_percent > 0.99
    end]]
    if name == "Monstrous Soul" and unit.health_percent < 0.4 then
        if unit.health_percent < 0.4 then
            score = 20
        elseif UnitCastingInfo(unitid) == explosionName or UnitChannelInfo(unitid) == explosionName then
            score = 20
        end
    elseif name == "Fiendish Soul" then
        if --[[spell == "Moonfire" or ]]spell == "Sunfire" then
            score = 0
        end
    elseif name == "Grim Reflection" then
        if spell == "Moonfire" or spell == "Sunfire" then
            score = 0
        else
            score = 40
        end
    elseif name == "Lost Soul" then
        if spell == "Moonfire" or spell == "Sunfire" and unit.health_percent < 0.5 then
            score = 0
        elseif UnitName("target") == "Lost Soul" or spell == "Sunfire" then
            return score + unit.health_percent, bossString
        else
            score = 0
        end
    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    local name = unit.name
    if name == "Grim Reflection" then
        return unit.health_percent < 0.99
    elseif name == "Fiendish Soul" then
        return
    else
        return true
    end
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Grim Reflection" then
        return true
    elseif name == "Monstrous Soul" then
        if unit.health_percent < 0.4 then
            return true
        elseif UnitCastingInfo(unitid) == explosionName or UnitChannelInfo(unitid) == explosionName then
            return true
        end
    end

    return false
end
--[[
WGBM[bossString].DamageCD = function(spell, unit, args)
    if (not args) or (not args[2]) then
        return true
    else--if args[2] > 30 then
        local now = GetTime()
        local intermissionIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            local intermissionIn = 1337
            if timeDiff < intermissionIn and timeDiff > -30 then
                if strmatch(msg, "Intermission") then
                    intermissionIn = timeDiff
                    if intermissionIn < -5 or intermissionIn > args[2] + 20 then                                                                                                                                                                                     20 then
                        return true
                    end
                end
            end
        end
    end
    --return true
end
]]

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name == "Anduin's Doubt" or name == "Anduin's Despair" then
        return true
    end
    return
end

WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    local class = UnitClass(unitid)
    if class == "Druid" then
        local manapercent = UnitPower(unitid) / UnitPowerMax(unitid);
        if manapercent < 0.9 and UnitCastingInfo(unitid) == "Wild Growth" then
            return true

        end
    end
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    --[[if unit.name == "Azsh'ari Witch" then
        return true
    end]]
    if count == 3 then
        print('should be interrupting')
        return true
    end
    return
end


WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    if unit:AuraStacks("Purging Light", "HARMFUL") >= 2 then
        if unit.health_percent < 0.9 then
            return args[2] <= 60

        end
    end
    local targetName = UnitName("target")
    if targetName == "Monstrous Soul" or targetName == "Remnant of a Fallen King" then
        if unit.health_percent < 0.6 then
            return args[2] <= 60

        end
    elseif targetName == "Anduin's Doubt" or targetName == "Anduin's Despair" then
        if unit.health_percent < 0.6 then
            return args[2] <= 60

        end
    end
end




local frame = CreateFrame("Frame")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if eventname == "UNIT_DIED" then
            if destName then
                --print(destName .. " died")
                if destName == "Grim Reflection" then
                    count = count + 1
                    print("Grim Reflection " .. count .. " died")
                    if count == 4 then
                        count = 0
                    end
                end
            end
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        count = 0
    end
end)
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")