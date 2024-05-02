

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Tarragrue"      -- not right at all
-- alt name
--local altName = "Sea Priest Blockade"
WGBM[bossString] = {}
--WGBM[altName] = WGBM[bossString]

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local player = WarGod.Unit:GetPlayer()
    if (player.health_percent < 0.8 and player:AuraRemaining("Grasp of Death", "HARMFUL") > 0) then
        return args[2] <= 60
    end
    --return 1337
end

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    local role = UnitGroupRolesAssigned(unitid)
    local class = UnitClass(unitid)
    if UnitIsUnit("player", unitid) then
        return 10
    end
    if role == "TANK" then
        return 9
    elseif class == "Rogue" or class == "Death Knight" or class == "Warrior" or class == "Demon Hunter" or class == "Paladin" or class == "Monk" then
        return 8
    elseif role == "HEALER" then
        return 7
    else
        return 6
    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    if unit:DebuffRemaining("Predator's Howl", "HARMFUL") > 0 then
        return true
    end
    local role = UnitGroupRolesAssigned(unit.unitid)
    if role == "HEALER" or role == "TANKER" then
        if unit:DebuffRemaining("Predator's Howl", "HARMFUL") > 0 then
            return true
        end
    end
end

WGBM[bossString].Mitigation = function(...--[[spell, unit, args]])
    --print(...)
    local spell, unit, args = ...
    if unit == nil then unit = WarGod.Unit:GetPlayer() end
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Overpower" then
            return true
        --elseif unit:DebuffRemaining("Crushed Armor","HARMFUL") > 0 then
        --    return true
        end
    end
    --end
    --return score, bossString
end

--w
--[[WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
end

WGBM[bossString].Cleanse = function(spell, unit, args)

end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return unit:BuffRemaining("Tempting Song", "HARMFUL") > 0
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Tempting Siren" then
        score = 20
    elseif name == "Energized Storm" then
        local health_percent = unit.health_percent
        if health_percent > 0.5 then
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
    if DoingMythic() then
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

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if (CastTimeFor(spell) >= 1.5) then
        local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < moveIn and timeDiff > -1 then
                if strmatch(msg, "Sea Swell") then
                    moveIn = timeDiff
                end
            end
        end

    end
    return moveIn
end]]