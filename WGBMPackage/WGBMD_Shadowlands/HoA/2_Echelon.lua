local WGBM = WarGod.BossMods

local bossString = "Echelon"
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
end]]


-- this should have a thing to stop from casting cooldowns near curse of stone

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    if UnitIsUnit(unitid, "player") then
        return true
    end
end
