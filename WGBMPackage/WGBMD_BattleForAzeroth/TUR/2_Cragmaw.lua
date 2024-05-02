local WGBM = WarGod.BossMods
local groups = WarGod.Unit.groups

local bossString = "Cragmaw the Infested"
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
    if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end
    return
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

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local unitid = unit.unitid
    local total = 0
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Serrated Fangs" then
            -- should do based on stacks probably
            local amount = select(16, UnitDebuff(unitid, i))
            total = total + unit.health_max * 0.2
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end

WGBM[bossString].AoeIn = function(spell, unit, args)
    local aoeIn = 1337
    local now = GetTime()
    if WarGod.Unit.active_enemies > 2 then
        return 0
    end
    for msg,time in pairs(WGBM.timers) do
        local timeDiff = time - now
        if timeDiff < aoeIn and timeDiff > -20 then
            if strmatch(msg, "Tantrum") then
                aoeIn = timeDiff + 15
            end
        end
    end
    return aoeIn

end