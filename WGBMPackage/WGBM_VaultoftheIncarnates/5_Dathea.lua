--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Dathea, Ascended"
WGBM[bossString] = {}

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    if name == "Thunder Caller" then
        return
    end
    return true
    --printTo(3,'default interrupt')
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local player = WarGod.Unit:GetPlayer()
    if spell == "Nature's Vigil" then

        if player.buff.incarnation_avatar_of_ashamane:Up() then
            return true
        end
        local incarnRemains = player.buff.incarnation_chosen_of_elune:Remains()
        if player.health_percent < 0.6 then
            if incarnRemains > 25 then
                return true
            elseif incarnRemains > 5 then
                return true
            end
        end
    else
        local targetName = UnitName("target")
        local guid = UnitGUID("target")
        local npcId = GetNPCId("target")
        -- what is the mob down the bottom?
        if (npcId == 192934 or targetName == "Dathea, Ascended") and UnitChannelInfo("boss1") == "Cyclone" then
            if player.health_percent < 0.5 and args[2] <= 180 then
                return true
            elseif player.health_percent < 0.8 and args[2] <= 60 then
                return true
            end
        elseif targetName == "Thunder Caller" or npcId == 197671 then
            if player.health_percent < 0.5 and args[2] <= 180 then
                return true
            elseif player.health_percent < 0.8 and args[2] <= 60 then
                return true
            end
        end
    end
end

--[[WGBM[bossString].DamageCD = function(spell, unit, args)
    --local npcId = GetNPCId("target")
    --if npcId then print(npcId) end
    if DoingMythic() then
        if GetNPCId("target") == 197671 then
            return true
        elseif args[2] < 120 then
            return true

        end
    else
        return true
    end
end]]

--[[WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if GetNPCId("target") == 197671 then
        return true
    end

    return false
end]]

WGBM[bossString].HealCD = function(spell, unit, args)
    if spell == "Innervate" then
        if GetSpecialization() ~= 2 or GetShapeshiftForm() ~= 2 or WarGod.Unit:GetPlayer().energy < 50--[[ and WarGod.Unit:GetPlayer():TimeInCombat() > 40]] then
            return true
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



WGBM[bossString].HealCD = function(spell, unit, args)
    if WarGod.Unit:GetPlayer():DebuffRemaining("Embrace of the Void","HARMFUL") > 0 then
        return
    elseif WarGod.Unit:GetPlayer():DebuffRemaining("Gift of N'Zoth: Lunacy", "HARMFUL") > 0 then
        return
    end
    --Gift of N'Zoth: Lunacy
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
end]]



WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid

    if UnitCastingInfo(unitid) == "Diverted Essence" then
        return
    elseif UnitChannelInfo(unitid) == "Diverted Essence" then
        return
    end
    return unit.health_percent < 0.8
    --printTo(3,'default interrupt')
end