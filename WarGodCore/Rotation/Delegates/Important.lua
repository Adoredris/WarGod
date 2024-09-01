local Rotation = WarGod.Rotation

local UnitBuff = C_UnitAuras.GetBuffDataByIndex
local UnitDebuff = C_UnitAuras.GetDebuffDataByIndex
local UnitAura = C_UnitAuras.GetAuraDataByIndex
setfenv(1, Rotation)

function ScoreByInvertedDebuffTimeRemaining(self, spell, unit, args)
    if Delegates:PriorityWrapper(spell, unit, args) > 0 then
        return 100 - unit:DebuffRemaining(args.spell or spell, "HARMFUL|PLAYER")

    end
    return 0
end

function ScoreByInvertedBuffTimeRemaining(self, spell, unit, args)
    if Delegates:PriorityWrapper(spell, unit, args) > 0 then
        return 100 - unit:BuffRemaining(args.spell or spell, "HELPFUL|PLAYER")

    end
    return 0
end

function FriendlyScoreByInvertedBuffTimeRemaining(self, spell, unit, args)
    --print(spell)
    if Delegates:FriendlyPriorityWrapper(spell, unit, args) > 0 then
        return 100 - unit:BuffRemaining(args.aura or spell, "HELPFUL|PLAYER")

    end
    return 0
end

function ScoreByInvertedHealth(self, spell, unit, args)
    if Delegates:PriorityWrapper(spell, unit, args) > 0 then
        return 1000000000 - unit.health

    end
    return 0
end

local interruptBuffer = random(100,500) * 0.001

local ccList = {
    "Banish",
    "Hibernate",
    "Polymorph",
    "Repentance",
    "Paralysis",
    "Hex",
    "Cyclone",
    "Sap",
    "Ghost Trap",
    "Shackle Undead",
    "Imprison",
    "Entangling Roots",
    "Mass Entanglement",
    "Fracking Totem",
}

function Delegates:UnitIsBreakableCrowdControlled(spell, unit, args)

    --if 1==1 then return false end
    --print('need to fix breakable cc')
    for i=1,40 do
        local name = UnitDebuff(unit.unitid, i)
        if not name then
            return false
        end
        if (tContains(ccList, name)) then
            --print('not dpsing ' .. UnitName(unit.unitid) .. ' cause ' .. name)
            return true
        end
    end

    return false
end

function Delegates:UnitIsFriend(spell, unit, args)
    if unit and IsSpellInRange(args.spell or spell, unit.unitId) then
        return true
    end
end

function Delegates:UnitIsEnemy(spell, unit, args)
    --print(spell)
    --print(unit.unitid)
    if unit and IsSpellInRange(args.spell or spell, unit.unitId) then
        return true
    end
end

function Delegates:IsExplosive(spell, unit, args)
    if unit and unit.name == "Explosives" then
        return true
    end
end

function Delegates:HasSpellToCleanse(spell, unit, args)

    --print('checkign HasSpellToCleanse')
    --if 1==1 then return false end
    local unitid = unit.unitid
    if UnitIsFriend("player", unitid) then
        for i=1,40 do
            local t = UnitDebuff(unitid, i)

            if(not t)then
                break
            end
            if (t.dispelName)then
                local dispellableauratypes = player.dispellableauratypes
                if not dispellableauratypes[t.dispelName] then
                    --printTo(3,"I can't dispel " .. debuffName .. " " .. auratype)
                    --return 0

                else
                    --print(unit.name .. " HasSpellToCleanse")
                    return true
                end

            end
        end
    end
end



function Delegates:UnitInCombat(spell, unit)
    return UnitAffectingCombat(unit.unitid)
end

function Delegates:HasEnrageMagicEffect(spell, unit, args)
    --print('need to fix HasEnrageMagicEffect')
    --if 1==1 then return false end
    local unitid = unit.unitid
    local score = 0
    for i=1,40 do
        local t = UnitBuff(unitid, i)
        if not t then return end
        if (t.dispelName == "Magic" or t.dispelName == "Enrage" or t.dispelName == "")then -- Enrages are "" for some reason?
            if (t.name == "Lifebloom")then
                return false
            end

            --if (duration > 0)then
            score = score + 1
            --end

            --return true
        end
    end
    if score > 0 then
        return true
    end

end

function Delegates:HasMagicEffect(spell, unit, args)
    --print('need to fix HasMagicEffect')
    --if 1==1 then return false end
    local unitid = unit.unitid
    local score = 0
    for i=1,40 do
        local t = UnitBuff(unitid, i)
        if not t then return end
        if (t.dispelName == "Magic")then
            if (t.name == "Lifebloom")then
                return false
            end

            --if (duration > 0)then
            score = score + 1
            --end

            --return true
        end
    end
    if score > 0 then
        return true
    end

end

function Delegates:HasEnrageEffect(spell, unit, args)
    --print('need to fix HasEnrageEffect')
    --if 1==1 then return false end
    local unitid = unit.unitid
    if unitid ~= "" then
        local score = 0
        for i=1,40 do
            local t = UnitBuff(unitid, i)
            if not t then return end
            if (t.dispelName == "Enrage" or t.dispelName == "")then -- Enrages are "" for some reason?
                --if (duration > 0)then
                score = score + 1
                --end

                --return true
            end
        end
        if score > 0 then
            return true
        end
    end
end

function Delegates:HasSpellToInterrupt(spell, unit, args)
    local unitid = unit.unitid

    local theTime = GetTime ()
    local lag = 0.2--GetOpt("AvLatency",0.1)
    local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo (unitid)
    if(spell ~= nil and notInterruptible == false) then-- and spellsThatCantOrShouldntBeInterrupted[spell] == nil
        --printTo(3,"Kickable spell: " .. spell)
        if (theTime - startTime / 1000 > interruptBuffer) then
            if((endTime / 1000) - lag > theTime)then
                return true
            end
        end
    end
    if(spell == nil)then
        spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo (unitid)
        if(spell ~= nil and notInterruptible == false) then-- and spellsThatCantOrShouldntBeInterrupted[spell] == nil
            --printTo(3,"Kickable spell: " .. spell)
            if (theTime - startTime / 1000 > interruptBuffer) then
                if((endTime / 1000) - lag > theTime)then
                    return true
                end
            end
        end
    end
    return false
end

function Delegates:HasSpellToInterrupt_LatestPossibleInterrupt (spell, unit, args)
    --print('HasSpellToInterrupt_LatestPossibleInterrupt')
    local unitid = unit.unitid
    local theTime = GetTime()
    local lag = 0.2--GetOpt("AvLatency",0.1)
    local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo (unitid)
    if(spell ~= nil and notInterruptible == false) then-- and spellsThatCantOrShouldntBeInterrupted[spell] == nil
        --printTo(3,"Kickable spell: " .. spell)
        if((endTime / 1000) - lag > theTime)then
            local castTime = (endTime - startTime) / 1000
            local castRemaining = (endTime / 1000) - theTime - lag
            local castCompletion = 100 * (1 - (castRemaining / castTime))
            --printTo(3, "Kickable spell of length : " .. castTime .. " with a kick-window of " .. castRemaining .. " at " .. (floor (castCompletion)) .. "%")
            if(castRemaining < interruptBuffer + lag * 3--[[0.6 or castCompletion > 75.0]])then--40.0%
                --printTo(3, "Late enough to kick, kicking")
                return true
            end
        end
    end
    if(spell == nil)then
        spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo (unitid)
        if(spell ~= nil and notInterruptible == false) then-- and spellsThatCantOrShouldntBeInterrupted[spell] == nil
            --printTo(3,"Kickable spell: " .. spell)
            if((endTime / 1000) - lag > theTime)then
                local castTime = (endTime - startTime) / 1000
                local castRemaining = (endTime / 1000) - theTime - lag
                local castCompletion = (1 - (castRemaining / castTime))
                --printTo(3,"Kickable spell of length : " .. castTime .. " with a kick-window of "..castRemaining .. " at " ..(floor(castCompletion)).."%" )
                --if (theTime - startTime / 1000 > interruptBuffer + lag) then
                    --print(castCompletion)
                    --if(castCompletion > 0.05 + interruptBuffer and castCompletion < 0.4)then--40.0% --or Moving ()
                        --print("Late enough to kick, or currently moving, kicking")

                        return true
                    --end
                --end
            end
        end
    end
    return false
end

function Delegates:UnitUnderXPercentHealth(spell, unit, args)
    local unitId = unit.unitid
    return UnitHealth(unitId) / UnitHealthMax(unitId) < (args and args.percent or 0.3)

    --return false
end

function Delegates:UnitOverXPercentHealth(spell, unit, args)
    local unitId = unit.unitid
    return UnitHealth(unitId) / UnitHealthMax(unitId) > (args and args.percent or 0.3)

    --return false
end

function Delegates:UnitOverXPercentHealthPredictedDamage(spell, unit, args)
    local unitId = unit.unitid
    if unitId ~= "" and unitId then
        --return UnitHealth(unitId) / UnitHealthMax(unitId) > (args and args.percent or 0.3)
        return (UnitHealth(unitId) - Delegates:ExtraHealthMissingWrapper(spell, unit, args)) / UnitHealthMax(unitId) > (args and args.percent or 0.3)
    end
    --return false
end

function Delegates:UnitUnderXPercentHealthPredicted(spell, unit, args)
    --local spell, unit, args = ...
    --[[if spell ~= "Regrowth" then
        print(unit.unitid)/
    end]]
    --[[if spell ~= "Regrowth" and spell ~= "Wild Growth" then
        print(...)

    end]]
    local unitId = unit.unitid
    if unitId ~= "" and unitId then
        return (UnitHealth(unitId) + (UnitGetIncomingHeals(unitId, "player") or 0) - Delegates:ExtraHealthMissingWrapper(spell, unit, args)) / UnitHealthMax(unitId) < (args and args.percent or 0.3)
    else

        --print('not unitid Delegates:UnitUnderXPercentHealthPredicted')
        --print(...)
        --print(unit.name)
    end

    --return false
end



function Delegates:UnitUnderXPercentHealthPredictedDamage(spell, unit, args)
    --local spell, unit, args = ...
    --[[if spell ~= "Regrowth" then
        print(unit.unitid)/
    end]]
    --[[if spell ~= "Regrowth" and spell ~= "Wild Growth" then
        print(...)

    end]]
    local unitId = unit.unitid
    if unitId ~= "" and unitId then
        return unit:PercentHealthPredictedDamage() < (args and args.percent or 0.3)
    else

        --print('not unitid Delegates:UnitUnderXPercentHealthPredicted')
        --print(...)
        --print(unit.name)
    end

    --return false
end

function Delegates:HarmIn8Yards(spell, unit, args)
    --print(unit.unitid)
    return IsItemInRange(32321, unit.unitid)
end

function Delegates:HarmIn10Yards(spell, unit, args)
    --print(unit.unitid)
    return IsItemInRange(32321, unit.unitid)
end

function Delegates:UnitIsBoss(spell, unit, args)
    for k,unitid in pairs(unit.unitIds) do
        if strmatch(unitid, "^boss") then
            return true
        end
    end
end

function Delegates:UnitIsNotPlayer(spell, unit, args)
    if UnitIsUnit(unit.unitid, "player") then
        return
    end
    return true
end

function Delegates:IsItemInRange(spell, unit, args)
    local unitId = unit.unitid
    if (not args) or type(args) ~= "table" then return end
    local itemId = args.itemId
    if itemId then
        return IsItemInRange(itemId, unitId)
    end
end

function Delegates:IsSpellInRange(spell, unit, args)
    --print('IsSpellInRange')
    --print(spell)
    if (args and args.spell) then
        spell = args.spell
    end
    local unitId = unit.unitid
    return IsSpellInRange(spell, unitId) == 1
end

function Delegates:IsSpellNotInRange(spell, unit, args)
    local unitId = unit.unitid
    if (args and args.spell and unitId ~= "") then
        return IsSpellInRange(args.spell, unitId) == 0
    end
end

function Delegates:UnitNotMoving(spell, unit, args)
    return GetUnitSpeed(unit.unitid) == 0
end
--[[function Delegates:UnitIsBoss(spell, unit, args)
    for k,v in pairs(unit.unitIds) do

    end
end]]