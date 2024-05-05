--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Huntsman Altimor"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end]]

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit("target",unitid) then
            return true
        end
    end
    if name == "Shade of Bargast" then
        if UnitIsUnit(unitid, "target") then
            return
        end
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10


    if name == bossString then
        score = 20
    elseif spell == "Sunfire" or spell == "Moonfire" and WarGod.Unit:GetPlayer().talent.twin_moons.enabled then
        if name == "Shade of Bargast" then
            return 0
        end
        local now = GetTime()
        local addsIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < addsIn and timeDiff > -10 then
                if strmatch(msg, "^Shades of Bargast") then
                    addsIn = timeDiff
                end
            end
        end
        if addsIn < 10 then
            print('blacklisting bear cause adds soon')
            return 0
        end
    end
    --end

    if (UnitIsUnit("target", unitid)) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    local name = unit.name
    local unitid = unit.unitid
    local addsIn = 1337
    if name ~= bossString then
        if spell == "Sunfire" or spell == "Moonfire" and WarGod.Unit:GetPlayer().talent.twin_moons.enabled then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < addsIn and timeDiff > -10 then
                    if strmatch(msg, "^Shades of Bargast") then
                        addsIn = timeDiff
                    end
                end
            end
        end
    end

    if addsIn < 10 then
        print('blacklisting bear cause adds soon')
        return true
    end
    return
end

--[[



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



WGBM[bossString].HealCD = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitChannelInfo(unitid) == "Obsidian Shatter" then  -- innervate in p2
        return true
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if args[2] > 120 and DoingMythic() then
        if WarGod.Unit:GetUnit("boss1"):BuffRemaining("Obsidian Skin","HELPFUL") == 0 then
            return
        else
            return true
        end
    end
    return true
end

]]