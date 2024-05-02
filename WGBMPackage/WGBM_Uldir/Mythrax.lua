--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Mythrax the Unraveler"      -- not right at all
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print("mythrax DPSBlacklist")
    local unitid = unit.unitid
    if UnitIsCharmed(unitid) then
        return true
    end
    if unit:BuffRemaining("Oblivion Veil", "HELPFUL") > 0 then
        return true
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
    --print("mythrax priority")
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    if name == bossString then
        score = 4
    elseif name == "Vision of Madness" then
        score = 20
    elseif name == "N'raqi Destroyer" then
        score = 20
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end
