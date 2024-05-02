--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Hivemind"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if spell == "Stellar Flare" or spell == "Moonfire" then
        local name = unit.name
        if name == "Aqir Darter" then
            return true
        end
    end
end

--[[WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name ~= "Tek'ris" and name ~= "Ka'zir" then
        if unit.health_percent > 0.3 then
            return true
        end
    end
end]]

WGBM[bossString].HealCD = function(spell, unit, args)
    --return
    local now = GetTime()
    local timeTill = 1337
    local combatTime = WarGod.Unit:GetPlayer():TimeInCombat()
    if combatTime < 60 then
        return true
    elseif combatTime > 150 then
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < timeTill and timeDiff > -20 and timeDiff < 0 then
                if strmatch(msg, "Volatile Eruption") then
                    return true
                end
            end
        end
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Aqir Drone" or name == "Volatile Drone") and DoingMythic() then
        if UnitCastingInfo(unitid) == "Volatile Eruption" then
            return true
        end
    elseif name == "Aqir Darter" and DoingMythic() and (not UnitIsUnit("target",unitid)) and WarGod.Unit:GetPlayer():TimeInCombat() > 60 and GetRaidTargetIndex(unitid) ~= 8 then
        return true
    end

    return
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Aqir Drone" then
        if UnitCastingInfo(unitid) == "Volatile Eruption" then
            return true
        end
    end

    return false
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    --print('hivemind priority')
    local name = unit.name
    if name == "Aqir Ravager" then
        score = 50
    elseif name == "Thing From Beyond" then
        local class = UnitClass("player")
        if class == "Druid" then
            if spell == "Entangling Roots" or spell == "Mass Entanglement" or spell == "Mighty Bash" then
                score = 100
            else
                score = 0
            end
        end
    elseif name == "Aqir Darter" then
        local index = GetRaidTargetIndex(unitid)
        if index then
            if index == 8 then
                score = score + 10
            end
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end


    return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Corrosion", "HARMFUL") > 0) then
        return args[2] <= 120
    end
    --return 1337
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    return true
end