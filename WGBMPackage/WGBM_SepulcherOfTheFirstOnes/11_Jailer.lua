

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Jailer"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    --[[if name == "Grim Reflection" then
        return unit.health_percent > 0.99
    end]]
    if name == "The Jailer" then
        --score = 20
    elseif name == "Incarnation of Torment" then
        score = 20
    else
        if spell == "Moonfire" or spell == "Sunfire" then
            score = 0
            return score, bossString
        else
            score = 40
        end

    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score, bossString
end