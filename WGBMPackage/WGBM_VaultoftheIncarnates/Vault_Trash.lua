--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
WGBM = WarGod.BossMods
local bossString = "Vault of the Incarnates"      -- not right at all
WGBM[bossString] = {}


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsPlayer(unitid) then
        return true
    end

    return false
end

--[[WGBM[bossString].DamageCD = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    print('boo')
end]]

--print('Uldir Trash')