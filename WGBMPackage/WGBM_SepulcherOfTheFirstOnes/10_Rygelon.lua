

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Rygelon"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end
    if name == "Unstable Matter" then
        if (not UnitIsUnit("target",unitid)) then
            return true
        end
    elseif name == "Cosmic Core" or name == "Unstable Core" then
        --return UnitChannelInfo(unitid) == "Gravitational Collapse"
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 10
    --[[if name == "Mal'Ganis" or name == "Kin'tessa" then
        return 30 + unit.health_percent
    end]]
    if name == "Collapsing Quasar" then
        if spell == "Moonfire" or spell == "Sunfire" then
            return 0, bossString
        elseif spell == "Devouring Plague" or spell == "Unholy Nova" or spell == "Shadow Word: Pain" then
            return 0, bossString
        elseif spell == "Shadow Word: Death" then
            if unit.health_percent < 0.2 then
                return 50, bossString
            end
        else
            score = 30 + unit.health_percent
        end
    end
    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    if unit.name == "Collapsing Quasar" then
        return
    --elseif unit.name == "Cosmic Core" then
    --    return unit.health_percent > 0.8
    end
    return true
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if (not args) or (not args[2]) then
        return true
    elseif args[2] > 30 then
        local now = GetTime()
        local intermissionIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            local intermissionIn = 1337
            if timeDiff < intermissionIn and timeDiff > -1 then
                if strmatch(msg, "Massive Bang") then
                    intermissionIn = timeDiff
                    if intermissionIn < 20 then
                        return
                    end
                end
            end
        end
    end
    return true
end