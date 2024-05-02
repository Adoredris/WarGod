

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Lady Ashvane"      -- not right at all
WGBM[bossString] = {}

local UnitAura = UnitAura
local GetTime = GetTime


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

WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    --local targetName = UnitName("target")

    if DoingMythic() and (args[2] > 120) then
        if WarGod.Unit.boss1:DebuffRemaining("Hardened Carapace","HELPFUL") == 0
                or WarGod.Unit:GetPlayer():BuffRemaining("Time Warp","HELPFUL") > 0
                or WarGod.Unit:GetPlayer():BuffRemaining("Heroism","HELPFUL") > 0 then
            return true
        --elseif WarGod.Unit:GetPlayer():TimeInCombat() < 15 then
            --return true
        end
        --[[if WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return
        elseif WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return

        else
            return true
        end]]
        return
    end
    return true
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossCasting = UnitCastingInfo("boss1")
    --if UnitIsUnit("boss1target", "player") then
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 and bossCasting == "Barnacle Bash" then
        return true
    end
    --end
    --return score, bossString
end

WGBM[bossString].Defensive = function(spell, unit, args)
    --[[if args[2] <= 60 then
        return true
    else]]if args[2] <= 120 and (WarGod.Unit:GetPlayer().health_percent < 0.5 or WarGod.Unit:GetPlayer():DebuffRemaining("Briny Bubble","HARMFUL") > 0) then
        return true
    end
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    --if (CastTimeFor(spell) >= 1.5) then
    --if spell == "Starfire" then
        local now = GetTime()
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < moveIn and timeDiff > -1 then
                if strmatch(msg, "Upsurge") then
                    moveIn = timeDiff
                end
            end
        end

    --end
    return moveIn
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    if name == "Briny Bubble" then
        if (spell == "Moonfire" or spell == "Sunfire" or spell == "Stellar Flare") and (not IsMoving()) then
            score = 0
        elseif unit.health_percent > 0.5 then
            score = 20 + unit.health_percent
        end
    else
        score = 10
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= "Lady Ashvane" and unit.health_percent > 0.9 and spell ~= "Stellar Flare" and spell ~= "Moonfire") then
        return true
    end
end


--[[
WGBM[bossString].EnoughTimeToCast = function(spell, unit, args)
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
end


--


WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Volatile Charge", "HARMFUL") > 0) then
        return args[2] <= 60 or unit.health_percent < 0.5 and args[2] <= 120
    elseif (unit:AuraRemaining("Liquid Gold", "HARMFUL") > 0) then
        return args[2] <= 120
    end
    --return 1337
end

]]