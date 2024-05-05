--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "The Council of Blood"      -- not right at all
WGBM[bossString] = {}

local upairs = upairs
print(upairs)

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    --[[if name == "Veteran Stoneguard" then
        score = 80
    else]]if name == "Dutiful Attendant" then
        score = 50
    elseif name == "Dancing Fools" then
        score = 60
    elseif name == "Baroness Frieda" then
        score = 20
    elseif name == "Castellan Niklaus" then
        score = 19
    elseif name == "Lord Stavros" then
        score = 18
    elseif name == "Begrudging Waiter" then
        if spell ~= "" then
            score = 0
        else
            score = 1
        end
    elseif strmatch(name, "Afterimage") then
        if spell ~= "Solar Beam" then
            score = 0
        else
            score = 10
        end
    else
        score = 17
    end
    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 5
    end
    return score, bossString
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name

    if unit:BuffRemaining("Unyielding Shield", "HELPFUL") > 0 then
        return true
    end
    if WarGod.Control:SafeMode() then
        if UnitIsUnit("target",unitid) then
            return
        end
        return true
    end


    if UnitGroupRolesAssigned("player") == "TANK" then
        return
    end
    if WarGod.Control:SafeMode() and not UnitIsUnit(unitid,"target") then
        return true
    end
    if UnitIsUnit(unitid, "boss1") or UnitIsUnit(unitid, "boss2") or UnitIsUnit(unitid, "boss3") then
        if UnitIsUnit(unitid, "target") then
            return
        end
        local hpPercent = unit.health_percent
        local WarGodUnit = WarGod.Unit
        for i=1,3 do
            local bossUnitId = "boss" .. i
            local bossName = UnitName(bossUnitId)
            if not bossName then return end
            if bossName ~= name then
                if WarGodUnit[bossUnitId].health_percent < hpPercent then
                    return true
                end
            end
        end
        for k,u in upairs(WarGod.Unit.groups.harmOrPlates) do
            if u.name == "Dutiful Attendant" then
                return true
            end
        end
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    --[[local name = unit.name
    if name == "Begrudging Waiter" or name == "Dutiful Attendant" then
        if unit.health_percent > 0.8 then
            return true
        end
    end]]
    return
end

WGBM[bossString].BurstUnit = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Dancing Fools" then
        return true
    elseif name == "Dutiful Attendant" then
        return true
    end

    return false
end

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            return
        end
        if debuffName == "Drain Essence" then
            if args[2] <= 150 then
                return true
            end
        end
    end
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    return true
end

--[[



WGBM[bossString].Taunt = function(spell, unit, args)
    local unitid = unit.unitid
    if unit.name == bossString then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Volatile Seed", "HARMFUL") <= 0 then
            if WarGod.Unit:GetUnit("boss1target"):DebuffRemaining("Volatile Seed", "HARMFUL") > 0 then
                print("Should Taunt")
                --return true
            end
        end
    end
end

WGBM[bossString].HealCD = function(spell, unit, args)
    --return
    local now = GetTime()
    local timeTill = 1337
    local combatTime = WarGod.Unit:GetPlayer():TimeInCombat()
    if combatTime > 45 and UnitClass("player") == "Druid" and GetSpecialization() == 1 then
        for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < timeTill then
                timeTill = timeDiff
                if timeDiff > -5 and timeDiff < 3 then
                    if strmatch(msg, "Entropic Crash") then
                        return true
                    end
                end
            end
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

WGBM[bossString].DamageCD = function(spell, unit, args)
    if args[2] > 60 then
        if WarGod.Unit:GetPlayer():DebuffRemaining("Void Infused Ichor", "HARMFUL") > 0 then
            return true
        end
    else
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if 1==1 then return true end
    return
end








WGBM[bossString].NotDotBlacklisted = function(spell, unit, args)
    if spell == "Primal Wrath" then
        if WarGod.Unit.active_enemies >= 4 then
            local numEnemies = 0
            for guid,unit in upairs(groups.harmOrPlates) do
                if Delegates:HarmIn10Yards("Rake", unit, {}) then
                    numEnemies = numEnemies + 1
                end
                if numEnemies >= 4 then
                    return true
                end
            end
        end
        return
    end
    if unit.name == "Zoatroid" then
        if UnitClass("player") == "Druid" then
            if GetSpecialization() == 1 then
                if spell ~= "Sunfire" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    return
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    return
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return
                elseif unit.health_percent < 0.4 then
                    return
                end
            end
        elseif UnitClass("player") == "Priest" then
            if WarGod.Unit:GetPlayer().talent.misery.enabled and spell == "Shadow Word: Pain" and (not IsMoving()) then
                return

            end
        end
    end
    return true
end

WGBM[bossString].MoveIn = function(spell, unit, args)
    local moveIn = 1337
    if WarGod.Unit:GetPlayer():DebuffRemaining("Incubation Fluid", "HARMFUL") > 0 then
        if (CastTimeFor(spell) >= 1.5) then
            local now = GetTime()
            for msg,time in pairs(WGBM.timers) do
                local timeDiff = time - now
                if timeDiff < moveIn and timeDiff > -1 then
                    if strmatch(msg, "Arcing Current") then
                        moveIn = timeDiff
                    end
                end
            end

        end
    end
    return moveIn
end

]]