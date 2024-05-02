--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Taloc"
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    --[[if (unit:AuraRemaining("Ravenous Blaze", "player", nil, true) > 0) then
        return args[2] <= 60
    end]]
    --return 1337
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Volatile Droplet") then
        return true
    elseif name == bossString then
        if unit:BuffRemaining("Powered Down","HELPFUL") > 0 then
            return true
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    if name == bossString then
        score = 10
    else
        score = 20
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end