local WGBM = WarGod.BossMods

local bossString = "Devos, Paragon of Doubt"
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

WGBM[bossString].CleansePriority = function(spell, unit, args)
    local unitid = unit.unitid
    local role = UnitGroupRolesAssigned(unitid)
    local class = UnitClass(unitid)
    local playerClass = UnitClass("player")

    if UnitGroupRolesAssigned("player") == "HEALER" then
        local remains, stacks =  unit:BuffRemaining("Lingering Doubt", "HARMFUL")
        stacks = stacks + 5
        if role == "TANKER" then
            stacks = stacks - 2
        end
        return stacks
    else
        return 1
    end
end