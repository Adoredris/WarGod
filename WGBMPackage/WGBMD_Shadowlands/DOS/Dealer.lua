local WGBM = WarGod.BossMods

local bossString = "Dealer Xy'exa"
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
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    --[[elseif name == "Experimental Sludge" then
        return true
    elseif name == "Atal'ai Devoted" then
        if UnitChannelInfo(unitid) == nil and UnitCastingInfo(unitid) == nil then
            return true
        end
    elseif name == "Atal'ai Deathwalker's Spirit" then
        return true]]
    elseif name == "Spiteful Shade" and UnitName("target") ~= "Spiteful Shade" then
        return true
    end

end