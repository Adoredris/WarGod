local WGBM = WarGod.BossMods

local bossString = "Executor Tarvold"
printTo(3,bossString)
WGBM[bossString] = {}

--[[WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Hateful Strike" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    --end
    --return score, bossString
end]]

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --if (addSoon and WarGodU)
    local score = 10
    if name ~= bossString then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
    --return WGBM.default.Priority(spell, unitid, args)
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
end

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsUnit("player", unitid) then
        return 10, bossString
    end
    local role = UnitGroupRolesAssigned(unitid)
    if role == "TANK" then
        return 1, bossString
    elseif role == "HEALER" then
        return 5, bossString
    else
        return 3 - unit.health_percent, bossString
    end
end