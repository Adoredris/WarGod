
local WGBM = WarGod.BossMods
local bossString = "Nerub-ar Palace"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('Nerub-ar Palace')
    if unit.name == "Rasha'nan" then
        if unit.health_percent < 0.59 then return end
        if (C_UnitAuras.GetBuffDataByIndex(unit.unitid, 2)) then return end
        return true
    end

    return
end