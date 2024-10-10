

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Silken Court"      -- not right at all
WGBM[bossString] = {}


--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print('boo')
    if UnitIsPlayer(unitid) then
        return true
    end
    --[[if UnitPhaseReason(unitid) ~= nil then
        print(name .. " not in phase")
        return true
    end]]
end

--[[WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if not UnitInPhase(unitid) then
        return true
    end
end]]

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= "Za'qul" and unit.health_percent > 0.5) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    if unit:BuffRemaining("Entangled", "HELPFUL") > 0 then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

--[[
WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local total = 0
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Gigavolt Charge" then
            --local amount = select(16, UnitDebuff(unitid, i))
            --print(amount)
            --if type(amount) == "number" then
                --total = total + amount
            --end
            total = total + unit.health_max * 0.1
        elseif debuffName == "Gigavolt Blast" then
                total = total + unit.health_max * 0.1
        elseif debuffName == "Gigavolt Radiation" then
            total = total + unit.health_max * 0.3
        elseif debuffName == "Buster Cannon" then
            total = total + unit.health_max * 0.2
        elseif debuffName == "Sheep Shrapnel" then
            total = total + unit.health_max * 0.2
        elseif debuffName == "Anti-Tampering Shock" then
            total = total + unit.health_max * 0.3
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            return
        end
        if debuffName == "Gigavolt Charge" then
            if args[2] <= 60 then
                if unit.health_percent < 0.5 then
                    return true
                else
                    if (unit:DebuffRemaining("Gigavolt Charge", "HARMFUL") < 1) then
                        return true
                    end
                end
            end
        elseif debuffName == "Gigavolt Blast" then
            if args[2] <= 60 and unit.health_percent < 0.7 then
                return true
            end
        elseif debuffName == "Gigavolt Radiation" then
            return true
        elseif debuffName == "Buster Cannon" then
            return true
        elseif debuffName == "Sheep Shrapnel" then
            return true
        elseif debuffName == "Anti-Tampering Shock" then
            return true
        end
    end
end

WGBM[bossString].HealCD = function(spell, unit, args)
    if WarGod.Unit.active_enemies > 0 then
        return true
    end
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if WarGod.Unit.active_enemies > 0 then
        if args[2] >= 150 then
            if WarGod.Unit:GetUnit("boss1").health_percent < 0.55 and WarGod.Unit:GetUnit("boss1").health_percent > 0.39 then
                return
            end
            return true
        elseif args[2] >= 90 then
            if WarGod.Unit:GetUnit("boss1").health_percent < 0.45 and WarGod.Unit:GetUnit("boss1").health_percent > 0.39 then
                return
            end
            return true
        else
            return true
        end
    end
end

]]