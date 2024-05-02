--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Sennarth, the Cold Breath"
WGBM[bossString] = {}

WGBM[bossString].HealCD = function(spell, unit, args)
    if spell == "Innervate" then
        if GetSpecialization() ~= 2 or GetShapeshiftForm() ~= 2--[[ or WarGod.Unit:GetPlayer().energy < 50 and WarGod.Unit:GetPlayer():TimeInCombat() > 40]] then
            return true
        end
    end
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if spell == "Nature's Vigil" then
        if UnitName("target") == "Frostbreath Arachnid" then
            return true
        end
    else
        if UnitCastingInfo("boss1") == "Gossamer Burst" then
            if WarGod.Unit:GetPlayer().health_percent < 0.5 and args[2] <= 180 then
                return true
            elseif WarGod.Unit:GetPlayer().health_percent < 0.8 and args[2] <= 60 then
                return true
            end
        end

    end
end

--[[
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if name == "Undying Guardian" and unit.health_percent < 0.4 then
        return true
    elseif UnitIsPlayer(unitid) then
        return true
    elseif WarGod.Control:SafeMode() and (not UnitIsUnit(unitid, "target")) then
        return true
    elseif name == "Uu'nat" and unit:BuffRemaining("Void Shield", "HELPFUL") > 0 then
        return true
    end
end

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

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Tempting Siren" then
        score = 20
    elseif name == "Energized Storm" then
        local health_percent = unit.health_percent
        if health_percent > 0.5 and unit:BuffRemaining("Kelp Wrapping", "HARMFUL") > 0 then
            score = 20
        end
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
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