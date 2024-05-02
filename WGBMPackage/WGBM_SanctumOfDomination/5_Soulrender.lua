

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Soulrender Dormazain"      -- not right at all
WGBM[bossString] = {}

local UnitAura = UnitAura
local GetTime = GetTime


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target",unit.unitid)) then
            return true
        end
    end
    if WarGod.Rotations.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then
        return true
    end
    return
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if name == "Mawsworn Agonizer" then
        --score = 30 + unit.health_percent
        if unit.health_percent < 0.05 then
            score = 1
        elseif unit:DebuffRemaining("Brand of Torment","HARMFUL") > 0 or unit:DebuffRemaining("Brand of Torment","HELPFUL") > 0 then
            --score = score + 10
        elseif unit.health_percent < 0.95 then
        elseif (not UnitIsUnit(unitid, "target")) then
            score = 0
        end
    elseif name == "Mawsworn Overlord" then
        score = 50
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].HealCD = function(spell, unit, args)
    if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
        local now = GetTime()
        local mechTime = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < mechTime and timeDiff > -10 then
                if strmatch(msg, "Chains") then
                    mechTime = timeDiff
                    if mechTime < 5 then
                        return true
                    end
                end
            end
        end
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if unit.name ~= bossString then
        if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
            local buff = WarGod.Unit:GetPlayer().buff
            if buff.starfall.down and IsMoving() then
                return
            end
            if buff.ravenous_frenzy.up then
                return true
            end
            if unit.health_percent < 0.8 then
                return true
            end
        end
    end
end

--[[WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
    local unitid = unit.unitid
    local castTime = CastTimeFor(spell)
    local remains = 10
    for i=1,3 do
        local name, _, count, auratype, duration, expirationTime = UnitAura (unitid, i, "HARMFUL")
        if(name==nil)then
            return true
        else
            local timeDiff = expirationTime - GetTime()
            if expirationTime and expirationTime > 0 and timeDiff < remains then
                if name == "Chaotic Displacement" or name == "Volatile Charge" then
                    remains = timeDiff
                end
            end
        end
    end
    if remains < 10 then

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
            print((castTime + 0.5) .. " > " .. remains)
            if castTime + 0.5 > remains then
                return
            end

        end
    end
    return true
end]]


--[[
WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    --local targetName = UnitName("target")

    if DoingMythic() and args[2] > 60 then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return
        elseif WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return
        else
            return true
        end
        return
    end
    return true
end
]]
WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Brand of Torment", "HARMFUL") > 0) then
        return args[2] <= 60 or unit.health_percent < 0.5 and args[2] <= 120
    end
    --return 1337
end

