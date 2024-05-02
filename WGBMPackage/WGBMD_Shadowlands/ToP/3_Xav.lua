local WGBM = WarGod.BossMods

local bossString = "Xav the Unfallen"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitChannelInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    if bossCasting == "Brutal Combo" then
        local bossThreat = UnitThreatSituation("player","boss1")
        if not bossThreat or bossThreat < 3 then
            return true
        end
    end
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff > -1 and timeDiff < 3 then
            if strmatch(msg, "Brutal Combo") then
                return true
            end
        end
    end
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

WGBM[bossString].Priority = function(spell, unit, args)
    local affixes = GetAffixes()
    local isBolstering = affixes.bolstering
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    --[[if (unit.name == "Explosives") then
        if UnitClass("player") == "Druid" then
            if spell == "Moonfire" or spell == "Sunfire" or GetSpecialization() == 2 then
                return 1000000, "default"
            else
                return
            end
        else
            return 1000000, "default"
        end
    end]]
    if name ~= bossString then
        score = 20
    end
    return score, bossString
end

WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    local unitid = unit.unitid
    local castTime = CastTimeFor(spell)
    local remains = unit:AuraRemaining("Quake", "HARMFUL")
    local roarRemains = CastTimeRemaining("boss1", "Deafening Crash")
    if roarRemains > 0 then
        if remains > 0 then
            remains = min(roarRemains, remains)
        else
            remains = roarRemains
        end
    end
    --print(spell)
    if remains > 0 then
        if castTime == 0 then
            if WarGod.Unit:GetPlayer().channels then
                local channels = WarGod.Unit:GetPlayer().channels
                if channels[spell] then
                    if channels[spell] - 0.25 > remains then
                        return
                    end
                end
            end
        else
            --print((castTime + 0.5) .. " > " .. remains)
            if castTime + 0.5 > remains then
                return
            end

        end
    end
    return true
end