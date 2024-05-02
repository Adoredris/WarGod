
local WGBM = WarGod.BossMods
local bossString = "Sepulcher of the First Ones"
WGBM[bossString] = {}

local reflectSpell = "Reflective Bulwark"

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() and (not UnitIsUnit(unitid,"target")) then
        return true
    end

    if UnitChannelInfo(unitid) == reflectSpell or UnitCastingInfo(unitid) == reflectSpell then
       return true
    end
end