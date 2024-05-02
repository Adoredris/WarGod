--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:51 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
printTo(3,"Archimonde")
local bossString = "Archimonde"

WGBM[bossString] = {}

-- this is more like a delegate
-- only really used for things that aren't flagged in combat
WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local name = unit.name
    if (name == "Doomfire Spirit")then
        return true
    end
end

WGBM[bossString].DamageCD = function(unitid)
    printTo(3,'checking archi DamageCD')
    if UnitName("boss1") == "Archimonde" and UnitHealthPercent("boss1") < 0.4 then
        printTo(3,'using archi DamageCD')
        return true
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unitid, args)
    --printTo(3,unitid)
    --[[if UnitChannelInfo(unitid) == "Bone Saw" or UnitChannelInfo(unitid) == "Fel Squall" then
        printTo(3,'not dpsing fel squall or bone saw')
        return true
    end]]

    return false
end