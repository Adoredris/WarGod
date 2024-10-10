--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Broodtwister Ovi'nax"      -- not right at all
WGBM[bossString] = {}

--[[WGBM[bossString].Interrupt = function(spell, unit, args)
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
end]]

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name == "Voracious Worm" and unit.health_percent > 0.7 then
            return true
    end
    return
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10

    if name == "Voracious Worm" and unit.health_percent > 0.2 then
        score = 50
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

--[[WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end]]



--[[
--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    local unitid = unit.unitid
    local name = unit.name
    if not UnitInPhase(unit.unitid) then
        print(name .. " not in phase")
    end
    if not WarGod.Control:SafeMode() then
        if unit:BuffRemaining("Seal of Reckoning","HELPFUL") > 0 then
            return true
        elseif unit:BuffRemaining("Divine Protection","HELPFUL") > 0 then
            return true
        elseif name ~= altName then
            if (not WarGod.Control:SafeMode()) and WarGod.Unit:GetUnit("boss1"):BuffRemaining("Seal of Retribution", "HELPFUL") > 0 then
                return true
            end
        end
    else
        if name ~= UnitName("target") then
            return true
        end
    end
end





WGBM[bossString].Purge = function(spell, unit, args)
    return true
end
]]