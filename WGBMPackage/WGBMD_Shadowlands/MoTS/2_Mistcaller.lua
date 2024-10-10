local WGBM = WarGod.BossMods

local bossString = "Mistcaller"
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

    --[[if name == "Mistcaller" then
        if unit:BuffRemaining("Guessing Game", "HELPFUL") > 0 then
            return true
        end
        return
    else]]if name == "Illusionary Clone" then
        if UnitIsUnit("target", unitid) then
            return
        end
        return true
    elseif name == "Illusionary Vulpin" then
        return true
    else
        --print("mistcaller default blacklist: " .. name)
    end

    return
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if name == "Mistcaller" then
        if unit:BuffRemaining("Guessing Game", "HELPFUL") > 0 then
            score = 1
        else
            score = 20
        end
    elseif name == "Illusionary Clone" then
        score = 50
    end
    return score, bossString
end