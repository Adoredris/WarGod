

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "King Rastakhan"      -- not right at all
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
    if WarGod.Unit:GetPlayer():BuffRemaining("Caress of Death", "HARMFUL") > 0 then
        if name ~= UnitName("target") then
            return true
        end
        if not UnitInPhase(unitid) then
            print(name .. " not in your phase")
        end
    else
        --[[if WarGod.Unit:GetPlayer():TimeInCombat() < 60 then
            if UnitName("target") == "Siegebreaker Roka" then
                if unit.name ~= "Siegebreaker Roka" then
                    return true
                end
            end
        end]]
        if name == bossString then
            if unit:BuffRemaining("Unliving", "HELPFUL") > 0 then
                return true
            elseif unit.health_percent > 0.999 then
                if WarGod.Unit:GetPlayer():TimeInCombat() < 20 and UnitThreatSituation(unitid .. "target","boss1") == nil then
                    return true
                elseif WarGod.Unit:GetPlayer():TimeInCombat() > 20 and unit:BuffRemaining("Bind Souls", "HELPFUL") > 0 and (not UnitIsUnit(unitid, "target")) then
                    return true
                end
            end

        elseif name == "Siegebreaker Roka" then
        elseif name == "Headhunter Gal'wana" then
        elseif name == "Prelate Za'lan" then
        elseif name == "Phantom of Retribution" then
            if UnitIsUnit("target",unitid) then
                return
            elseif unit:DebuffRemaining("Undying Relentlessness","HELPFUL") > 0 then
                return
            else
                return true
            end
        elseif name == "Phantom of Rage" then
            if UnitIsUnit("target",unitid) then
                return
            elseif unit:DebuffRemaining("Undying Relentlessness","HELPFUL") > 0 then
                return
            else
                return true
            end
        elseif name == "Phantom of Slaughter" then
            if UnitIsUnit("target",unitid) then
                return
            elseif unit:DebuffRemaining("Undying Relentlessness","HELPFUL") > 0 then
                return
            else
                return true
            end
        elseif name == "Zombie Dust Totem" then
        elseif name == UnitName("target") then
        else
            return true
        end
    end
end

WGBM[bossString].FriendlyBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    if not UnitInPhase(unitid) then
        return true
    end
    if unit:DebuffRemaining("Caress of Death","HARMFUL") > 0 then
        return true
    end
end

WGBM[bossString].HealCD = function(spell, unit, args)
    if UnitName("target") == "Bwonsamdi" and GetUnitpeed(unit.unitid) == 0 then
        return true
    elseif WarGod.Unit:GetUnit("boss1").health_percent < 0.4 then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 10
    local name = unit.name
    local targetName = unit.name
    if name == "Zombie Dust Totem" and (unit.health_percent > 0.2 or targetName == name) then
        score = 50
    elseif name == "Siegebreaker Roka" and unit.health_percent > 0.05 then
        score = 25
    elseif name == "Headhunter Gal'wana" and unit.health_percent > 0.1 then
        score = 16
    elseif name == "Prelate Za'lan" and unit.health_percent > 0.1 then
        score = 16
    elseif name == "Phantom of Retribution" and unit.health_percent > 0.1 then
        score = 16
    elseif name == "Phantom of Rage" and unit.health_percent > 0.1 then
        score = 16
    elseif name == "Phantom of Slaughter" and unit.health_percent > 0.1 then
        score = 16
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    return
end
--
WGBM[bossString].DamageCD = function(spell, unit, args)
    local bossHp = WarGod.Unit:GetUnit("boss1").health_percent
    if bossHp > 0.55 and bossHp < 0.75 and args[2] > 30 then
        return
    end
    if WarGod.Unit:GetPlayer():TimeInCombat() > 10 then
        if bossHp < 0.6 and bossHp > 0.5 and IsMoving() then
            return
        end
        return true
    end
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if unit.name == "Zombie Dust Totem" and unit.health_percent < 0.5 then
        return true
    end
end