
local WGBM = WarGod.BossMods
local bossString = "Ny'alotha, the Waking City"      -- not right at all
WGBM[bossString] = {}


WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsUnit("player", unitid) then
        return 1
    end
    return 0.5
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    if unit:DebuffRemaining("Heartpiercer Venom", "HARMFUL") > 0 then
        return true
    elseif unit:DebuffRemaining("Curse of the Void", "HARMFUL") > 0 then
            return true
    end
    return
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Anubisath Sentinel") then
        if unit:BuffRemaining("Astral Reflection", "HELPFUL") > 0 then
            return true
        end
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10

    if unit:BuffRemaining("Astral Reflection", "HELPFUL") > 0 then
        local class = UnitClass(unitid)
        if class == "Druid" then
            if spell == "Moonfire" or spell == "Sunfire" or spell == "Wrath" or spell == "Starfire" or spell == "Starsurge" or spell == "Stellar Flare" then
                return 0, bossString
            end

        end
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end