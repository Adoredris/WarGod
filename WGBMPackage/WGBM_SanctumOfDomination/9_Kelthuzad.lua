

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Kel'Thuzad"      -- not right at all
--local altName = "Mekkatorque"
WGBM[bossString] = {}
--WGBM[altName] = WGBM[bossString]


WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    if args[2] <= 60 then
        local remains = WarGod.Unit:GetPlayer():DebuffRemaining("Frost Blast","HARMFUL")
        if remains > 6 or remains > 0 and remains < 2 then
            return true
        end
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < -1 and timeDiff > -6 then
                if strmatch(msg, "Meteor") then
                    --for guid,unit in upairs(WarGod.Unit.groups.help) do
                    --    remains =  unit:DebuffRemaining("Frost Blast","HARMFUL")
                    --    if remains > 0 and remains < 2 then
                            return true
                    --    end
                    --end
                end
            end
        end
    end
    --return 1337
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if unit.name == "Frostbound Devoted" then
        if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
            if spell == "Moonfire" then
                return true
            end
        end
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print('boo')
    if WarGod.Control:SafeMode() and UnitExists("target") then
        if UnitIsUnit("target", unitid) then
           return
        end
        return true
    end
    if name == "Glacial Spike" then
        if UnitIsUnit("target", unitid) then
            return
        elseif unit.num_targetting > GetNumGroupMembers() * 0.3 then
            return
        else
            return true
        end

    --[[elseif name == "Soul Reaver" then
        if UnitIsUnit("target", unitid) then
            return
        else
            return true
        end]]
    end
end


WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name

    if name == "Glacial Spike" then
        if UnitIsUnit("target",unitid) then
            score = 30
        else
            score = 1
        end
    elseif name == "Frostbound Devoted" then
    elseif name == "Unstoppable Abomination" then
        return 5 + unit.health * 0.0000001
    elseif name == "Remnant of Kel'Thuzad" then
    elseif name == "Soul Reaver" then
        return 5 + unit.health * 0.00000001
    elseif name == bossString then
    else--mind controlled players or tank adds
        if UnitGroupRolesAssigned("player") ~= "TANK" then
            score = 20 + unit.health_percent
        end
        if spell == "Fury of Elune" then
            score = 1
        end
    end
    if UnitIsUnit("target",unitid) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Soul Fracture" then
            return true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return
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
            if WarGod.Unit.boss1.health_percent < 0.55 and WarGod.Unit.boss1.health_percent > 0.39 then
                return
            end
            return true
        elseif args[2] >= 90 then
            if WarGod.Unit.boss1.health_percent < 0.45 and WarGod.Unit.boss1.health_percent > 0.39 then
                return
            end
            return true
        else
            return true
        end
    end
end

]]

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    --[[if name == "Soul Reaver" then
        local marker = GetRaidTargetIndex(unitid)
        if marker == 8 then
            return true
        end
    end]]
    return
end