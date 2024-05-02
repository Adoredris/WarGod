--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Echo of Neltharion"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end
    if name == "Neltharion" then
        return

    elseif unit.name == "Voice From Beyond"--[[ and UnitName("target") == "Voice From Beyond"]] then
        return

    elseif unit.name == "Twisted Aberration" then
        return
    end
    return true
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Voice From Beyond" then
        score = 30
        --if unit:BuffRemaining("Flame Shield","HELPFUL") > 0 then
        --end
    else
    end

    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score
end

--[[WGBM[bossString].HealCD = function(spell, unit, args)
    if spell == "Innervate" then
        local now = GetTime()
        local aoeIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < aoeIn and timeDiff > -5 then
                if strmatch(msg, "Pushback") then
                    aoeIn = timeDiff
                    if timeDiff < 2 then
                        return
                    end
                end
            end
        end
        if GetSpecialization() ~= 2 or GetShapeshiftForm() ~= 2 or WarGod.Unit:GetPlayer().energy < 50 then
            if WarGod.Unit:GetPlayer():TimeInCombat() > 40 then
                return true
            end
        end
    end
end]]

WGBM[bossString].Defensive = function(spell, unit, args)
    local chargeRemains = WarGod.Unit:GetPlayer():DebuffRemaining("Static Charge","HARMFUL")
    if chargeRemains > 0 and chargeRemains < 3 then
        return true
    end
    if args[2] <= 60 then

        local now = GetTime()
        local aoeIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < aoeIn and timeDiff > -1 then
                if strmatch(msg, "Explosion") then
                    aoeIn = timeDiff
                    if timeDiff < 4 then
                        return true
                    end
                end
            end
        end
    elseif spell == "Nature's Vigil" then
        if --[[WarGod.Unit.boss1:BuffRemaining("Stormsurge","HELPFUL") > 0 or ]]WarGod.Unit:GetPlayer().buff.incarnation_avatar_of_ashamane:Up() then
            return true
        end
    end
end



WGBM[bossString].Interrupt = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    --[[if name == "Stormseeker Acolyte" then
        return
    elseif name == "Volatile Spark" then
        return true
    end
    return true]]
    if GetRaidTargetIndex(unitid) == 3 then
        return true
    end
end

--[[WarGod.BossMods.default.DotBlacklisted = function(spell, unit, args)
    if strmatch(unit.name, "Totem$") then
        return true
    end
end]]

--[[




WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    return
end
WGBM[bossString].FriendlyPriority = function(spell, unit, args)
    if unit:BuffRemaining("Bwonsamdi's Wrath", "HARMFUL") > 0 and spell ~= "Remove Corruption" then
        return 0
    else
        return 10 - unit.health_percent
    end
end



WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:BuffRemaining("Crawling Hex", "HARMFUL") > 0 then
        return 0
    end
    if UnitGroupRolesAssigned(unitid) == "TANK" then
        return 2
    elseif UnitIsUnit("player",unitid) then
        return 1.9
    else
        return 1.5 - unit.health_percent

    end
end
]]