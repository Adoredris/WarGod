--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Orgozoa"      -- not right at all
WGBM[bossString] = {}

WGBM[bossString].Interrupt = function(spell, unit, args)
    if unit.name == "Azsh'ari Witch" then
        return true
    end
    return
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].DotQuick = function(spell, unit, args)
    local name = unit.name
    if 1==1 then return end
    if name == "Zoatroid" and unit.health_percent > 0.7 and spell == "Vampiric Touch" and WarGod.Unit:GetPlayer().talent.misery.enabled--[[ and spell ~= "Stellar Flare"]] then
        --[[if spell == "Sunfire" then
            if GetUnitpeed(unit.unitid) == 0 then
                return true
            end
        else]]
            return true
        --end
    end
    return
end

WGBM[bossString].Priority = function(spell, unit, args)
    --print('default priority')
    local unitid = unit.unitid
    local name = unit.name
    local score = 10
    if WarGod.Control:SafeMode() then
        if (not UnitIsUnit("target", unitid) and unit.name ~= bossString) then
            return 0
        end
    end
    if name == "Orgozoa"--[[ and unit.health_percent > 0.4]] then

        if WarGod.Control:FocusFire() then
            score = 100
        elseif UnitClass("player") == "Priest" and GetSpecialization() == 3 then
            if spell == "Mind Sear" then
                score = 0
            elseif spell == "Dark Void" then
                score = 0
            elseif spell == "Void Eruption" then
                score = 100 - max(unit:DebuffRemaining("Shadow Word: Pain", "HARMFUL|PLAYER"), unit:DebuffRemaining("Vampiric Touch", "HARMFUL|PLAYER"))
            end
        end
    elseif name == "Zoatroid" then
        if unit:BuffRemaining("Chaotic Growth", "HELPFUL") > 0 then
            score = 1
        elseif (UnitName("target") == name or spell == "Void Eruption" or spell == "Void Bolt") and unit.health_percent > 0.25 then
            score = 11 + unit.health_percent
        else
            score = 5
        end
        --if unit.name == "Zoatroid" then
        local class = UnitClass("player")
        if class == "Druid" then
            if GetSpecialization() == 1 then
                if spell == "Moonfire" or spell == "Stellar Flare" then
                    score = 0
                elseif unit.health_percent > 0.95 or GetUnitpeed(unit.unitid) > 0 then
                    score = 0
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    score = 0
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    score = 0
                elseif spell == "Rake" and unit.health_percent < 0.4 then
                    score = 0
                end
            end
        elseif class == "Priest" then
            if GetSpecialization() == 3 then
                if spell == "Vampiric Touch" then
                    if (not WarGod.Unit:GetPlayer().talent.misery) then
                        score = 0

                    elseif unit.health_percent < 0.3 then
                        score = 0
                    end
                elseif spell == "Shadow Word: Pain" then
                    if (not IsMoving()) then
                        score = 0
                    end
                elseif (spell == "Dark Void") then
                    if unit.health_percent > 0.95 or GetUnitpeed(unit.unitid) > 0 then
                        score = 0
                    end
                elseif spell == "Void Eruption" then
                    score = 100 - max(unit:DebuffRemaining("Shadow Word: Pain", "HARMFUL|PLAYER"), unit:DebuffRemaining("Vampiric Touch", "HARMFUL|PLAYER"))
                end
            end
        end
    elseif GetRaidTargetIndex(unitid) == 8 then
        if spell == "Void Eruption" then
            score = 100 - max(unit:DebuffRemaining("Shadow Word: Pain", "HARMFUL|PLAYER"), unit:DebuffRemaining("Vampiric Touch", "HARMFUL|PLAYER"))
        else
            score = 20
        end
    end
    if (UnitIsUnit("target", unitid)) and score > 0 then
        score = score + 1
    end
    return score, bossString
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3--[[ and WarGod.Rotations.Delegates:IsItemInRange(spell, unit, {itemId = 10645})]] then
        return true
    end
    --end
    --return score, bossString
end

WGBM[bossString].DotBlacklisted = function(spell, unit, args)
    if spell == "Primal Wrath" then
        if WarGod.Unit.active_enemies >= 4 then
            local numEnemies = 0
            for guid,unit in upairs(groups.harmOrPlates) do
                if Delegates:HarmIn10Yards("Rake", unit, {}) then
                    numEnemies = numEnemies + 1
                end
                if numEnemies >= 4 then
                    return
                end
            end
        end
        return
    end
    if unit.name == "Zoatroid" then
        if UnitClass("player") == "Druid" then
            if GetSpecialization() == 1 then
                if spell ~= "Sunfire" then
                    return true
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return true
                elseif unit.health_percent < 0.4 and (not IsMoving()) then
                    return true
                end
            elseif GetSpecialization() == 2 then
                if spell == "Rip" then
                    return true
                elseif unit.health_percent > 0.9 or GetUnitpeed(unit.unitid) > 0 then
                    return true
                elseif unit.health_percent < 0.4 then
                    return true
                end
            end
        elseif UnitClass("player") == "Priest" then
            if WarGod.Unit:GetPlayer().talent.misery.enabled and spell == "Shadow Word: Pain" and (not IsMoving()) then
                return true

            end
        end
    end
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

WGBM[bossString].DamageCD = function(spell, unit, args)
    for i=1,5 do
        local name = UnitBuff("boss1",i)
        if name == nil then
            return true
        elseif name == "Massive Incubator" then
            return
        end
    end
    return true
end



--[[
--WGBM[bossString].Defensive = function(spell, unit, args)
--    local unitid = unit.unitid
--    if (unit:AuraRemaining("Ravenous Blaze", "HARMFUL") > 0) then
--        return args[2] <= 60
--    end
--    --return 1337
--end
--
WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --print('boo')
    local unitid = unit.unitid
    local name = unit.name
    if not UnitInPhase(unit.unitid) then
        print(name .. " not in phase")
    end
    if not WarGod.Control:SafeMode() then
        if unit:BuffRemaining("Seal of Reckoning","HELPFUL") > 0 then
            return true
        elseif unit:BuffRemaining("Divine Protection","HELPFUL") > 0 then
            return true
        elseif name ~= altName then
            if (not WarGod.Control:SafeMode()) and WarGod.Unit.boss1:BuffRemaining("Seal of Retribution", "HELPFUL") > 0 then
                return true
            end
        end
    else
        if name ~= UnitName("target") then
            return true
        end
    end
end





WGBM[bossString].Purge = function(spell, unit, args)
    return true
end
]]