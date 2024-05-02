local WGBM = WarGod.BossMods

local bossString = "Lord and Lady Waycrest"
printTo(3,bossString)
WGBM[bossString] = {}


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    --print('boo')
    if (unit:AuraRemaining("Soul Armor", "HELPFUL") > 0) then
        --printTo(3,'not dpsing with Soul Armor buff')
        return true
    end

    return false
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local boss2Casting = UnitCastingInfo("boss2")
    --if UnitIsUnit("boss1target", "player") then
    if boss2Casting == "Wasting Strike" then
        return true
    end
    --end
    --return score, bossString
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:BuffRemaining("Virulent Pathogen", "HARMFUL") > 0 then
        return
    end
    return
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    return aoeIn
end