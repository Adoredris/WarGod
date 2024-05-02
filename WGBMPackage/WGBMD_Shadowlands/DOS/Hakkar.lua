local WGBM = WarGod.BossMods

local bossString = "Hakkar the Soulflayer"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Piercing Barb" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    local now = GetTime()
    local mechTime = 1337
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < mechTime and timeDiff > -10 then
            if strmatch(msg, "Piercing Barb") then
                mechTime = timeDiff
                if mechTime < 3 then
                    return true
                end
            end
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
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
    local name = unit.name
    if WarGod.Control:SafeMode() then
        if not UnitIsUnit(unitid, "target") then
            return true
        end
    end
    --[[if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    elseif name == "Experimental Sludge" then
        return true
    elseif name == "Atal'ai Devoted" then
        if UnitChannelInfo(unitid) == nil and UnitCastingInfo(unitid) == nil then
            return true
        end
    elseif name == "Atal'ai Deathwalker's Spirit" then
        return true
    else]]
    if name == "Spiteful Shade" and UnitName("target") ~= "Spiteful Shade" then
        return true
    end

end