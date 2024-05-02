local WGBM = WarGod.BossMods

local bossString = "Temple of the Jade Serpent"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    if (unit:AuraRemaining("Water Bubble", "HELPFUL") > 0) then
        printTo(3,'not dpsing with Soul Armor buff')
        return true
    end

    return false
end

--[[WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name == "Spirit of Gold") then
        return true
    end
end]]

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Depraved Mistweaver" then
        local cast = UnitCastingInfo(unitid)
        if cast == "Defiling Mist" then
            -- only interrupt if the target is low health
            return (UnitHealth(unitid .. "target") or 0) / (UnitHealthMax(unitid .. "target") or 1) < 0.5
        end
        return
    elseif name == "Fallen Waterspeaker" then
        local cast = UnitCastingInfo(unitid)
        if cast == "Hydrolance" then
            -- only interrupt if the target is low health
            return (UnitHealth(unitid .. "target") or 0) / (UnitHealthMax(unitid .. "target") or 1) < 0.5
        elseif cast == "Tidal Burst" then
            return true
        end
        return
    end
    return true
end