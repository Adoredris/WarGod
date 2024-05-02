

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Sylvanas Windrunner"      -- not right at all
--local altName = "Mekkatorque"
WGBM[bossString] = {}
--WGBM[altName] = WGBM[bossString]


WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if unit:BuffRemaining("Banshee Shroud","HELPFUL") > 0 then
        return true
    elseif name == "Anduin Wrynn" then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    --if spell == "Wrath" then print('Sylvanas priority for wrath') end
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid)) then
            return 0, bossString
        end
    end
    if name == "Decrepit Orb" then
        if UnitIsUnit("target", unitid) then
            score = 60
        else
            score = 0
        end
    elseif name == "Mawforged Souljudge" then
        score = 50
    elseif name == "Mawforged Summoner" then
        score = 40
    end

    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    return
end

-- don't know about this args[2] stuff for this fight, think about it when I try a different class
WGBM[bossString].DamageCD = function(spell, unit, args)
    if WarGod.Unit.active_enemies > 0 then
        if args[2] < 90 then
            return true
        elseif WarGod.Unit.boss1.health_percent > 0.9 then
            return args[2] <= 180
        elseif WarGod.Unit.boss1.health_percent < 0.75 and GetZoneText() ~= "Edge of the Abyss" then
            return true
        elseif GetZoneText() == "Edge of the Abyss" then
            if args[2] < 180 then
                return true
            elseif args[2] >= 180 then
                if WarGod.Unit.boss1:BuffRemaining("Banshee Shroud","HELPFUL") == 0 then
                    return true
                end
            end
        else
        end
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        local bossCasting = UnitCastingInfo("boss1")
        if bossCasting == "Wailing Arrow" then
            return true
        elseif bossCasting == "Ranger's Heartseeker" then
            return true
        end
    end
    --end
    --return score, bossString
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    return
end


--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
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



]]