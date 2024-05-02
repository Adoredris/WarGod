

--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Prototype Pantheon"      -- not right at all
WGBM[bossString] = {}

local DamageReductionBuff = "Imprinted Safeguards"

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --print("Blockade Blacklist")
    if UnitChannelInfo(unitid) == "Complete Reconstruction" then
        return true
    end
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit(unitid, "target")) then
            return true
        end
    end
    if name == "Necrotic Ritualist" then
        if UnitName("target") == name then
            return
        end
        if WarGod.Unit:GetPlayer():TimeInCombat() < 45 then
            return
        elseif WarGod.Unit:GetPlayer():TimeInCombat() > 180 then
            if DoingMythic() then
                if WarGod.Unit.boss1.health_percent > 0.5 and WarGod.Unit.boss2.health_percent > 0.5 and WarGod.Unit.boss3.health_percent > 0.5 and WarGod.Unit.boss4.health_percent > 0.5 then
                    return true
                end
            else
                return true
            end
        else
            return true
        end
    end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local name = unit.name
    local score = 10
    if name == "Prototype of Absolution" then
        if unit.health_percent < 0.4 then
            return 30 + unit.health_percent
        elseif unit.health_percent < 0.55 and UnitIsUnit("target", unit.unitid) then
            return 40
        else
            return 30 + unit.health_percent
        end
    elseif name == "Prototype of War" or name == "Prototype of Renewal" then
        return 30 + unit.health_percent
    elseif name == "Prototype of Duty" then
        return 30 + (UnitIsUnit(unit.unitid, "target") and 0.05 or 00) + unit.health_percent -- + unit.health / 10000000
    end
    if name == "Pinning Weapon" then
        score = 50
    elseif name == "Necrotic Ritualist" then
        if (spell ~= "Moonfire" and spell ~= "Sunfire") and unit:BuffRemaining(DamageReductionBuff, "HELPFUL") > 0 and (not UnitIsUnit("target", unit.unitid)) then
            return 0, bossString
        else

            score = 40 + unit.health / 10000000
        end
    end
    if (UnitIsUnit(unit.unitid, "target")) then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Necrotic Ritualist" and UnitIsUnit("target", unitid) and WarGod.Unit:GetPlayer().buff.starfall:Up() and unit:BuffRemaining(DamageReductionBuff, "HELPFUL") <= 0 then
        return true
    end

    return false
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if name == "Necrotic Ritualist" then
        if unit:BuffRemaining(DamageReductionBuff, "HELPFUL") > 0 then
            return true
        end
    end
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    if UnitClass("player") == "Druid" and GetSpecialization() == 1 then
        if 1==1 then return true end
        local now = GetTime()
        local intermissionIn = 1337
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            local intermissionIn = 1337
            if timeDiff < intermissionIn and timeDiff > -10 then
                if strmatch(msg, "Hand") then
                    intermissionIn = timeDiff
                    if intermissionIn < 2 then
                        return true
                    end
                elseif strmatch(msg, "Pinning Volley") then
                    intermissionIn = timeDiff
                    if intermissionIn < 2 then
                        return true
                    end
                elseif strmatch(msg, "Winds") then
                    intermissionIn = timeDiff
                    if intermissionIn < 2 then
                        return true
                    end
                end
            end
        end
    else
        -- ideally this would read rt notes and such too
        return true
    end
end