

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Queen Azshara"
WGBM[bossString] = {}


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("azshara blacklist " .. name)
    if UnitIsPlayer(unitid) then
        return true
    elseif (unit:BuffRemaining("Crystalline Shield", "HELPFUL") > 0) then
        return true
    elseif name == "Cyranus" or name == "Queen Azshara" or name == "Aethanel" then
        return false
    else
        local targetName = UnitName("target")
        if (targetName == "Lady Venomtongue" or targetName == "Serena Scarscale") and unit:BuffRemaining("Crystalline Shield", "HELPFUL") <= 0 then
            if name ~= targetName then
                return true
            end
        end
        if name == "Loyal Myrmidon" then
            if targetName ~= name then
                return true
            end
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