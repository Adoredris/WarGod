--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Maut"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end]]

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name ~= bossString then return true end
    return
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    local curseRemaining = unit:BuffRemaining("Ancient Curse", "HARMFUL")
    if curseRemaining > 0 then
        if UnitIsUnit(unitid, "player") then
            return true
        else
            local unitClass = UnitClass(unitid)
            if curseRemaining < 20 and UnitGroupRolesAssigned(unitid) == "DAMAGER"
                    and unitClass ~= "Shaman" and unitClass ~= "Mage" and unitClass ~= "Druid" then
                return true
            elseif curseRemaining < 5 then
                return true
            end
        end

    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid)) then
            return 0, bossString
        end
    end
    if DoingMythic() and name == "Dark Manifestation" then
        local bossPowerPercent = (UnitPower("boss1") or 0) / (UnitPowerMax("boss1") or 1)
        if bossPowerPercent < 0.5 then
            score = 15

        end
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitChannelInfo(unitid) == "Obsidian Shatter" then  -- innervate in p2
        return true
    end
end

--[[WGBM[bossString].DamageCD = function(spell, unit, args)
    if args[2] > 120 and DoingMythic() then
        if WarGod.Unit.boss1:BuffRemaining("Obsidian Skin","HELPFUL") == 0 then
            return
        else
            return true
        end
    end
    return true
end]]