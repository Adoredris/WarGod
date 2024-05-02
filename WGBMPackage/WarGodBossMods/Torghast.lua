local WGBM = WarGod.BossMods
local bossString = "Torghast, Tower of the Damned"      -- not right at all
WGBM[bossString] = {}

-- this doesn't seem to load until a pull timer atm?

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local cast = UnitCastingInfo(unitid) or UnitChannelInfo(unitid)
    if cast == "Shadow Spear" then
        return false
    elseif cast == "Eternal Torment" then
            return false
    elseif cast == "Fireball" then
        return false
    elseif cast == "Soul Rip" then
        return false
    elseif name == "Empowered Coldheart Ascendant" then
        return true
    elseif name == "Empowered Mawsworn Flametender" then
        return cast == "Inner Flames"
    elseif name == "Empowered Mawsworn Soulbinder" then
        return true
    elseif name == "Empowered Coldheart Agent" then
        return cast == "Terror"
    elseif name == "Empowered Deadsoul Shambler" then
        return true
    elseif name == "Dark Ascended Corrus" then
        if cast == "Shadow Rip" then
            return
        else
            return true
        end
    elseif name == "Flameforge Master" then
        return
    elseif name == "Forge Keeper" then
        return true
    elseif name == "Watchers of Death" then
        if cast == "Steal Vitality" then
            return
        else
            return true
        end
    elseif name == "Mawsworn Guard" then
        return
    end
    return true
end

WGBM[bossString].Purge = function(spell, unit, args)
    local unitid = unit.unitid
    return true
end