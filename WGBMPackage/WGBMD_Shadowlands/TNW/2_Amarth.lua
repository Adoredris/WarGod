local WGBM = WarGod.BossMods

local bossString = "Amarth, The Harvester"
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

WGBM[bossString].Cleanse = function(spell, unit, args)
    return true
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name ~= bossString then return true end
    return
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    end
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local casting = UnitCastingInfo(unitid)
    local channel = UnitChannelInfo(unitid)
    if name == "Amarth" then
        return
    end
    return true
end