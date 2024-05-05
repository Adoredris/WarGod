local WGBM = WarGod.BossMods
local groups = WarGod.Unit.groups

local bossString = "Elder Leaxa"
printTo(3,bossString)
WGBM[bossString] = {}


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    local unitid = unit.unitid
    --if UnitAffectingCombat(unitid) then return end  -- hoping this lets through the things that are fighting at the entrance
    local name = unit.unitid
    if WarGod.Control:SafeMode() then
        if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
            return
        end
        return true
    end


    if name == "Incorporeal Being" then return true end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end
    return
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --if (addSoon and WarGodU)
    local score = 10
    if name == "Blood Effigy" then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
    --return WGBM.default.Priority(spell, unitid, args)
end

--[[WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --if (addSoon and WarGodU)
    local score = 10
    if name == "Blood Visage" then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
    --return WGBM.default.Priority(spell, unitid, args)
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    return true
end]]

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    if (not UnitIsUnit(unitid, "boss1")) then
        return
    end
    return true
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -2 then
            if strmatch(msg, "Blood Mirror") then
                aoeIn = timeDiff + 0.5
            end
        end
    end
    local spellName, displayName, icon, WasStartedAt, ShouldEndAt, isTradeSkill, castID, notInterruptible = UnitCastingInfo("boss1")
    if spellName == "Blood Mirror" then
        aoeIn = ShouldEndAt / 1000 - now + 0.5
    end
    return aoeIn

end