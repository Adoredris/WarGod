local WGBM = WarGod.BossMods

local bossString = "Margrave Stradama"
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
    local name = unit.name
    local unitid = unit.unitid
    local score = 7
    if WarGod.Control:SafeMode() then
        if UnitIsUnit(unitid, "target") then
            return 10, bossString
        end
        if name ~= bossString then
            return 0, bossString
        end
    end
    if name == "Malignant Spawn" and UnitIsUnit("target", unitid) then
        score = 30
    elseif name == "Margrave Stradama" then
        score = 10
    end
    if UnitIsUnit("target", unitid) then
        score = score + 5
    end
    return score, bossString
end