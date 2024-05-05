--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Forgotten Experiments"
WGBM[bossString] = {}


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if name == "Lurking Lunker" then
        return true
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    --print('experiments')
    if args[2] <= 60 then return true end
    if WarGod.Rotation.SatedRemaining() > 0 then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Neldris" then
        score = 24
    elseif name == "Thadrion" then
        score = 20
    elseif name == "Erratic Remnant" then
        if UnitIsUnit(unitid, "target") or unit.health_percent > 0.3 then
            score = 50 + unit.health * 0.0000001
        end

    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    local name = unit.name
    if name == "Erratic Remnant" then
        return true
    end
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if spell == "Nature's Vigil" then
        if WarGod.Unit:GetPlayer().health_percent < 0.5 then
            if WarGod.Unit:GetPlayer():DebuffRemaining("Seismic Assault", "HARMFUL") > 0 then
                return true
            end
        end
    else
        --[[local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < 3 and timeDiff > -1 then
                if strmatch(msg, "Dust") then
                    if args[2] <= 60 then
                        return true
                    elseif timeDiff < 2 and (args[2] <= 180 and WarGod.Unit:GetPlayer().health_percent < 0.65 or WarGod.Unit:GetPlayer().health_percent < 0.8 and WarGod.Unit:GetPlayer().buff.barkskin:Down()) then
                        return true
                    end
                end
            end
        end]]
        local player = WarGod.Unit:GetPlayer()
        local bombStacks = player:AuraStacks("Unstable Essence", "HARMFUL")
        if bombStacks > 5 then
            local disintegrateRemains = player:AuraStacks("Disintegrate", "HARMFUL")
            if disintegrateRemains > 5 then
                return true
            elseif player.health_percent < 0.05 * bombStacks then
                return true
            end
        end
    end
end

WGBM[bossString].HealCD = function(spell, unit, args)
    if spell == "Innervate" then
        if WarGod.Unit:GetPlayer():TimeInCombat() > 20 then
            return true
        end
    end
end

--[[
WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    for i=1,10 do
        local debuff = UnitDebuff(unitid, i)
        if (not debuff) then return end
        if (debuff == "Embrace of the Void") then
            --printTo(3,'not dpsing with Soul Armor buff')
            return true
        elseif (debuff == "Insatiable Torment") then
            return true
        end
    end

    return
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if WarGod.Unit:GetPlayer():DebuffRemaining("Storm of Annihilation","HARMFUL") > 0 then
        return
    end
    return true
end


WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    if (spell == "Moonfire" and WarGod.Unit:GetPlayer().talent.twin_moons.enabled or spell == "Sunfire") then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Gift of N'Zoth: Lunacy", "HARMFUL") > 0 then
            return
        end
    end
    return true
end

WGBM[bossString].Cleanse = function(spell, unit, args)

end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid

    if UnitCastingInfo(unitid) == "Catastrophic Tides" then
        return
    end
    return true
    --printTo(3,'default interrupt')
end

WGBM[bossString].AllowedToInterrupt = function(spell, unit, args)
    local unitid = unit.unitid
    --print("checking interrupts on " .. unitid)
    if UnitCastingInfo(unitid) == "Catastrophic Tides" then
        print("skipping interrupts")
        return false
    end
    return true
end
]]