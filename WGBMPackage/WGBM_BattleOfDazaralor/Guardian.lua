

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Opulence"      -- not right at all
WGBM[bossString] = {}

local UnitAura = UnitAura
local GetTime = GetTime


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
    --[[local remains = unit:AuraRemaining("Chaotic Displacement", "HARMFUL")
    local chargeRemains = unit:AuraRemaining("Volatile Charge", "HARMFUL")
    if (chargeRemains < remains) then
        remains = chargeRemains
    end]]
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

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 0
    local name = unit.name
    if name == "Spirit of Gold" then
        score = 20 + unit.health_percent
    else
        score = 10
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end
--
WGBM[bossString].DamageCD = function(spell, unit, args)
    --local unitId = unit.unitid
    --if unitId ~= "" then
    --local targetName = UnitName("target")

    if DoingMythic() and args[2] > 60 then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return
        elseif WarGod.Unit:GetPlayer():DebuffRemaining("Chaotic Displacement","HARMFUL") > 0 then
            return
            --[[elseif WarGod.Unit:GetTarget().health_percent < 0.89 and not IsMoving() and UnitExists("targettarget") then
                return true
            elseif UnitName("target") == "Opulence" then
                return true]]
        else
            return true
        end
        return
    end
    return true
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    if (unit:AuraRemaining("Volatile Charge", "HARMFUL") > 0) then
        return args[2] <= 60 or unit.health_percent < 0.5 and args[2] <= 120
    elseif (unit:AuraRemaining("Liquid Gold", "HARMFUL") > 0) then
        return args[2] <= 120
    end
    --return 1337
end

