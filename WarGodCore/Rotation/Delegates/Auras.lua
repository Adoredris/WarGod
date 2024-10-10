local WarGod = WarGod
local Rotation = WarGod.Rotation
setfenv(1, Rotation)

function CanPersonallySeeUnit(unit)
    for i,unitid in pairs(unit.unitIds) do
        if unitid == "target" or unitid == "mouseover" or strmatch(unitid, "^name") then
            return true
        end
    end
end


function GetEffectiveGroupDPS(unit)
    local dps = 0
    local guid = unit.guid
    for k,v in upairs(groups.targetable) do
        if (not v.dead) then
            local targetingMulti = (v.target == unit.guid and 1 or 0.1)
            dps = dps + (v.health_max * (v.role == "DAMAGER" and 0.08 or 0.03)) * targetingMulti
            --print(#v.unitIds)
        end
    end
    return dps
end

function IsMoving()
    return GetUnitSpeed("player") > 0 or IsFalling()
end

function CastTimeFor(spell)
    --funnyschoolthing seems to return Lunar or Solar depending on spells for moonkins
    local t = GetSpellInfo(spell)
    if not t then return 0 end
    --print('boo')
    return (t.castTime or 0)/1000
end

-- having trouble perfecting this crap

function Delegates:DoT_Exists(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < 1.5
    --return aura.remains < 1
    if WarGod.BossMods.Priority(spell, unit, args) > 0 then
        local stacks = unit.debuff[SimcraftifyString(args and args.aura or spell)]:Stacks()
        return stacks > 0

    end
end

function Delegates:DoT_Missing(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < 1.5
    --return aura.remains < 1
    if WarGod.BossMods.Priority(spell, unit, args) > 0 then
        local remains, stacks = unit.debuff[SimcraftifyString(args and args.aura or spell)]:Remains() - CastTimeFor(spell)
        return remains <= 0
    end
end

function Delegates:DoT_Pandemic(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < args.threshold
    --return unit.unitIds[1]
    if WarGod.BossMods.Priority(spell, unit, args) > 0 then
        return unit.debuff[SimcraftifyString(args and args.aura or spell)]:Remains() < (args and args.threshold or 1.5) + CastTimeFor(spell)
    end
end

function Delegates:HoT_Missing(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < 1.5
    --return aura.remains < 1
    local remains, stacks = unit.buff[SimcraftifyString(args and args.aura or spell)]:Remains() + CastTimeFor(spell)
    return remains <= 0
end

function Delegates:HoT_Pandemic(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < args.threshold
    --return unit.unitIds[1]
    return unit.buff[SimcraftifyString(args and args.aura or spell)]:Remains() < (args and args.threshold or 1.5) + CastTimeFor(spell)
end



-- adds existing aura duration to the ttd requirement
function Delegates:DoT_TTD_Estimate(spell, unit, args)
    if strmatch(unit.name, "Dummy") or (not IsInInstance()) then return true end
    local existing = unit.debuff[SimcraftifyString(args and args.aura or spell)]:Remains()
    local minimum = args and args.ttd or 0
    local total = existing + minimum


    -- dodgy version
    local groupDPS = GetEffectiveGroupDPS(unit)

    if UnitIsPlayer(unit.unitid) then return true end

    --return true
    return groupDPS * total < unit.health
end

function Delegates:TTD_GT_DoT_Remains(spell, unit, args)
    if strmatch(unit.name, "Dummy") then return true end
    local existing = unit:AuraRemaining(args and args.aura or spell, "HARMFUL|PLAYER")


    -- dodgy version
    local groupDPS = GetEffectiveGroupDPS(unit)

    --return true
    return unit.health / groupDPS > existing
end

function Delegates:DoT_Anti_Pandemic(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < args.threshold
    --return unit.unitIds[1]
    return unit:AuraRemaining(args and args.aura or spell, "HARMFUL|PLAYER") > (args and args.threshold or 1.5)
end

--[[function Delegates:Rush_DoT(spell, unit, args)
    return player:TimeInCombat() > 30 and unit.name == "Plague Amalgam" and unit.health_percent > 0.8
end]]

function Delegates:NotCastingThisAtTargetAlready(spell, unit, args)
    return spell ~= player.casting and spell ~= player.prev_gcd

end

function Delegates:NotDotBlacklisted(spell, unit, args)
    --print(...)
    return (not Delegates:DotBlacklistedWrapper(spell, unit, args))

end

function Delegates:NotAoeBlacklisted(spell, unit, args)
    return (not Delegates:DotBlacklistedWrapper(spell, unit, args))

end