

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Lords of Dread"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end

    if name == "Inchoate Shadow" then
        return unit:BuffRemaining("Incomplete Form","HELPFUL") > 0
    elseif name == "Kin'tessa" then
        return
    elseif name == "Mal'Ganis" then
        return

    elseif UnitIsUnit("target",unitid) then
        return true
    end
    return true
    --[[if name == "Unstable Matter" then
        if (not UnitIsUnit("target",unitid)) then
            return true
        end
    end]]
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    --[[local unitid = unit.unitid
    local name = unit.name
    local casting = UnitCastingInfo(unitid)
    local channel = UnitChannelInfo(unitid)
    if name == "Amarth" then
        return
    end
    return true]]
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 10
    if name == "Mal'Ganis" or name == "Kin'tessa" then
        return 30 + unit.health_percent
    end
    if name == "Inchoate Shadow" then
        score = 50
    end
    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < 3 and timeDiff > -5 then
            if strmatch(msg, "Chain Slam") then
                if args[2] <= 60 then
                    return true
                end
            end
        end
    end
end