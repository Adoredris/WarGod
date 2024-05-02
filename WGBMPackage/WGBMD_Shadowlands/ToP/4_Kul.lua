local WGBM = WarGod.BossMods

local bossString = "Kul'tharok"
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

WGBM[bossString].Defensive = function(spell, unit, args)
    if args and args[2] <= 60 then
        if unit:DebuffRemaining("Phantasmal Parasite", "HARMFUL") > 0 then
            return true
        end
    end
end

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    local role = UnitGroupRolesAssigned(unitid)
    local class = UnitClass(unitid)
    local playerClass = UnitClass("player")
    if UnitGroupRolesAssigned("player") == "HEALER" then
        if role == "HEALER" then
            return 5
        elseif role == "TANK" then
            return 1
        else
            return 3 - unit.health_percent
        end
    else
        return 1
    end
end