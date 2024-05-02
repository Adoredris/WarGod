--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Champion of the Light"      -- not right at all
local altName = "Ra'wani Kanae"
WGBM[bossString] = {}
WGBM[altName] = WGBM[bossString]


--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
--[[WGBM[bossString].DPSBlacklist = function(spell, unit, args)
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
            if (not WarGod.Control:SafeMode()) and WarGod.Unit.boss1:BuffRemaining("Seal of Retribution", "HELPFUL") > 0 then
                return true
            end
        end
    else
        if name ~= UnitName("target") then
            return true
        end
    end
end]]

WGBM[bossString].Interrupt = function(spell, unit, args)
    -- only interrupt if you have the debuff thingy on you (thinking priority is to not get multiple stacks, rather than to avoid them entirely
    local casting = UnitCastingInfo(unit.unitid)
    if casting == "Angelic Renewal" or casting == "Heal" then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local index = 1
    if unitid and unitid ~= "" then
        index = GetRaidTargetIndex(unitid)
        if not index then
            if UnitIsUnit(unitid, "target") then
                index = 1
            else
                index = 0
            end
        else
            if index < 7 and index > 1 then
                if UnitIsUnit(unitid, "target") then
                    index = 1
                else
                    index = 0
                end
            end
        end
    end
    if not UnitInPhase(unit.unitid) then
        print(name .. " not in phase")
        return 0
    end
    if UnitGroupRolesAssigned("player") ~= "TANK" then
        if spell == "Solar Beam" then
            return 100
        end
        if not WarGod.Control:SafeMode() then
            if unit:BuffRemaining("Seal of Reckoning","HELPFUL") > 0 then
                return 0
            elseif unit:BuffRemaining("Divine Protection","HELPFUL") > 0 then
                return 0
            elseif name ~= altName then
                if (not WarGod.Control:SafeMode()) and WarGod.Unit.boss1:BuffRemaining("Seal of Retribution", "HELPFUL") > 0 then
                    if unit.health_percent < 0.5 or name ~= "Zandalari Crusader" then
                        return 0
                    end
                end
            end
        else
            if name ~= UnitName("target") then
                return 0
            end
        end

    end
    return index + 2, "default"
end

WGBM[bossString].Purge = function(spell, unit, args)
    return true
end