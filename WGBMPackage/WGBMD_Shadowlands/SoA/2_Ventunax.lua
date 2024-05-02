local WGBM = WarGod.BossMods

local bossString = "Ventunax"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if WarGod.Unit:GetPlayer():DebuffRemaining("Dark Stride", "HARMFUL") > 0 then
        return true
    end
end