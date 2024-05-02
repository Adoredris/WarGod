local WGBM = WarGod.BossMods
local bossString = "Artificer Xy'mox"
WGBM[bossString] = {}

WGBM[bossString].Defensive = function(spell, unit, args)
    if WarGod.Unit:GetPlayer():DebuffRemaining("Withering Touch","HARMFUL") > 0 then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == bossString then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end


    return score, bossString
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if spell == "Stellar Flare" and unit.name ~= bossString then
        return true
    end
    return
end

--[[

WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end

WGBM[bossString].HealCD = function(spell, unit, args)
    return
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if 1==1 then return true end
    return
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    if UnitIsUnit("focus", unit.unitid) or UnitClass("player") == "Druid" and GetRaidTargetIndex(unit.unitid) == 6 then
        return true
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        if UnitCastingInfo("boss1") == "Abyssal Strike" then
            return true, nil, true
        end
    end
    --end
    --return score, bossString
end






WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if WarGod.Unit:GetPlayer():DebuffRemaining("Incubation Fluid", "HARMFUL") > 0 then
        if (CastTimeFor(spell) >= 1.5) then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < moveIn and timeDiff > -1 then
                    if strmatch(msg, "Arcing Current") then
                        moveIn = timeDiff
                    end
                end
            end

        end
    end
    return moveIn
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end

]]