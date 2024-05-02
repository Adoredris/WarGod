local WGBM = WarGod.BossMods

local bossString = "The Manastorms"
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

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    if UnitDebuff(unitid, 1) == nil then
        return true
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    local now = GetTime()
    if (not UnitExists("boss1")) or (not UnitExists("boss2")) then
        return true
    end
    if args[2] <= 60 then
        return true
    end
    if UnitName("target") == "Millificent Manastorm" then
        return true
    end
    for guid,unit in upairs(WarGod.Unit.groups.harmOrPlates) do
        if unit.name == "Millificent Manastorm" then
            return true
        end
    end
end