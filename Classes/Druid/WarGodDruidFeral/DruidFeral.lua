if UnitClass("player") ~= "Druid" then C_AddOns.DisableAddOn("WarGodDruidFeral"); return end
local Druid = WarGod.Class

local Rotation = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local variable = player.variable
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


local print = print

local min = min
local max = max
local strmatch = strmatch
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local tinsert = tinsert
local tContains = tContains
local WarGodUnit = WarGod.Unit
local harmOrPlates = WarGodUnit.groups.targetableOrPlates

-------------Stuff needed for delegate only---------------
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitPowerMax = UnitPowerMax
local UnitPower = UnitPower
local UnitCastingInfo = UnitCastingInfo
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitClass = UnitClass
local UnitIsUnit = UnitIsUnit
local UnitIsFriend = UnitIsFriend

local WarGodControl = WarGod.Control
local WarGodRotations = WarGod.Rotation

----------------------------------------------------------
local GetTime = GetTime
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetSpellInfo = C_Spell.GetSpellInfo
local GetPowerRegen = GetPowerRegen
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

local Delegates = WarGodRotations.Delegates
local Feral = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidFeral", "AceConsole-3.0", "AceEvent-3.0")

setfenv(1, Rotation)



function player:Setup()
    --print("feral setup")
    variable.finishers = talent.bloodtalons.enabled and player.combopoints > 4 or (not talent.bloodtalons.enabled) and player.combopoints > 3
    variable.use_thrash = (azerite.wild_fleshrending.enabled and 2 or 0)

    local ripMultiplier = 1
    local genericMultiplier = 1
    if buff.bloodtalons:Stacks() > 0 then
        ripMultiplier = ripMultiplier * 1.3
    end
    if buff.tigers_fury:Stacks() > 0 then
        ripMultiplier = ripMultiplier * 1.15
        genericMultiplier = genericMultiplier * 1.15
    end
    variable.ripMultiplier = ripMultiplier
    variable.genericMultiplier = genericMultiplier
    --variable.opener = player:TimeInCombat() < 5 and WarGodUnit.active_enemies < 3 and (WarGodSpells["Tiger's Fury"]:CDRemaining() < 3 or buff.tigers_fury:Stacks() > 0 or buff.bloodtalons:Stacks() > 0)

    local numEnemiesInMelee = 0
    local numBoomyDotsNeeded = 0
    local sunfireNeeded = false
    for guid,unit in upairs(groups.targetable) do
        if Delegates:IsSpellInRange("Rake", unit, {}) then
            numEnemiesInMelee = numEnemiesInMelee + 1
        end
        if Delegates:NotDotBlacklisted("Moonfire", unit, {}) then
            if Delegates:DoT_Pandemic("Moonfire", unit, {}) then
                numBoomyDotsNeeded = numBoomyDotsNeeded + 1
            end
            if Delegates:DoT_Pandemic("Sunfire", unit, {}) then
                numBoomyDotsNeeded = numBoomyDotsNeeded + 1
                sunfireNeeded = true
            end
        end
    end
    variable.numEnemiesInMelee = numEnemiesInMelee
    variable.numBoomyDotsNeeded = numBoomyDotsNeeded
    variable.sunfireNeeded = sunfireNeeded

    player.energy = UnitPower("player", 3)
end



function Delegates:DotGTCurMultiplier(spell, unit, args)
    local activeMultiplier = unit[spell .. "Multiplier"]
    if (not activeMultiplier) then
        return true
    end
    local spellMultiplier = (spell == "Rip" or spell == "Primal Wrath" or spell == "Ferocious Bite") and variable.ripMultiplier or variable.genericMultiplier
    if spellMultiplier > activeMultiplier * (args and args.multiplierModifier or 1) then
        return true
    end
end

function Delegates:CreatesMaxMultiplier(spell, unit, args)
    local activeMultiplier = unit[spell .. "Multiplier"]
    if (not activeMultiplier) then
        return
    end
    if activeMultiplier < 1.4 then
        return true
    end
end

function Delegates:DotLTCurMultiplier(spell, unit, args)
    return (not Delegates:DotGTCurMultiplier(spell, unit, args))
end

function Delegates:EnergyToRakeAfterShred(spell, unit, args)
    return unit:DebuffRemaining("Rake","HARMFUL|PLAYER") > (((buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0) and 45 or 75) - player.energy) / GetPowerRegen()
end

do
    player.biggestGenAmount = 20

    player.mana_cost = 0
    player.Mana_Percent = function(self)
        return (self.mana - self.mana_cost) / self.mana_max
    end
    player.Mana = function(self)
        return (self.mana - self.mana_cost)
    end
    player.lunar_gen = 0
    player.Lunar_Power = function(self)
        return self.lunarpower + self.lunar_gen
    end
    player.Lunar_Power_Deficit = function(self)
        return self.lunarpower_deficit - self.lunar_gen
    end
end

local bs_inc = {}
player.bs_inc = bs_inc
function bs_inc:Up()
    return self:Remains() > 0
end

function bs_inc:Down()
    return self:Remains() <= 0
end

function bs_inc:Remains()
    if talent.incarnation_avatar_of_ashamane.enabled then
        return buff.incarnation_avatar_of_ashamane:Remains()
    end
    return buff.berserk:Remains()
end

function bs_inc:Duration()
    if talent.incarnation_avatar_of_ashamane.enabled then
        return buff.incarnation_avatar_of_ashamane:Duration()
    end
    return buff.berserk:Duration()
end


--setmetatable(spell_targets, {__})
do
    local firstDamageTimes = {
        Moonfire = GetTime(),
        Sunfire = GetTime(),
        ["Wrath"] = GetTime(),
        ["Starfire"] = GetTime(),
        Starfall = GetTime()
    }
    local lastDamagedTargets = {
        Moonfire = {},
        Sunfire = {},
        ["Wrath"] = {},
        ["Starfire"] = {},
        Starfall = {},
    }
    local spell_targets_blacklist = {
        moonfire = {"Starfall"},
        sunfire = {"Starfall", "Moonfire"},
        solar_wrath = {"Starfall", "Moonfire"},
        lunar_strike = {"Starfall", "Moonfire"},
        starfall = {},
    }

    local spell_targets = {}
    setmetatable(spell_targets, {__index = function(t, lowerSpell)
        --if (lowerSpell == "moonfire") then
        local now = GetTime()
        local maxUnits = 0
        for spell,time in pairs(firstDamageTimes) do
            if (not tContains(spell_targets_blacklist[lowerSpell], spell)) then
                if (now - time < 5) then
                    local units = 0
                    for k,v in pairs(lastDamagedTargets[spell]) do
                        units = units + 1
                    end
                    if (units > maxUnits) then
                        maxUnits = units
                    end
                end
            end
        end
        return min(WarGodUnit.active_enemies, max(1, maxUnits))
        --end
        --return 1
    end})
    --[[setmetatable(spell_targets, {__index = function(t, lowerSpell)
        if (lowerSpell == "moonfire") then
            local now = GetTime()
            local maxUnits = 0
            for spell,time in pairs(firstDamageTimes) do
                if (not tContains(spell_targets_blacklist, spell)) then
                    if (now - time < 5) then
                        local units = 0
                        for k,v in pairs(lastDamagedTargets[spell]) do
                            units = units + 1
                        end
                        if (units > maxUnits) then
                            maxUnits = units
                        end
                    end
                end
            end
            return max(1, maxUnits)
        end
        return 1
    end})]]

    local lastCastTime = {}
    function Feral:UNIT_SPELLCAST_SUCCEEDED(event, unitid, castGUID, spellId)
        if unitid == "player" then
            -- tracking last time each generator was cast
            -- rake = 1822
            -- thrash = 106830
            -- brutal slash = 202028
            -- shred = 5221
            -- swipe = 106785
            lastCastTime[GetSpellInfo(spellId).name] = GetTime()
        end

    end
    Feral:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    function Delegates:FeralFullyDotted(spell, unit, args)
        if unit:DebuffRemaining("Rip","HARMFUL|PLAYER") > 0 and unit:DebuffRemaining("Rake","HARMFUL|PLAYER") > 0 then
            return true
        end
    end

    function Delegates:SpellWasNotCastInLast4Seconds(spell, unit, args)
        if GetTime() - (lastCastTime[spell] or 0) >= 4 then
            return true
        end
    end
    function player:SpellWasNotCastInLast4Seconds(spell)
        if GetTime() - (lastCastTime[spell] or 0) >= 4 then
            return true
        end
    end
    function player:NumGeneratorsInLast4Seconds()
        local now = GetTime()
        local num = 0
        if now - (lastCastTime["Rake"] or 0) < 4 then
            num = num + 1
        end
        if now - (lastCastTime["Swipe"] or 0) < 4 then
            num = num + 1
        end
        if now - (lastCastTime["Thrash"] or 0) < 4 then
            num = num + 1
        end
        if now - (lastCastTime["Brutal Slash"] or 0) < 4 then
            num = num + 1
        end
        if now - (lastCastTime["Shred"] or 0) < 4 then
            num = num + 1
        end
        return num
    end

    function Feral:COMBAT_LOG_EVENT_UNFILTERED(event)
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if player.guid == sourceGUID then
            if spellName == "Rip" then
                if eventname == "SPELL_AURA_APPLIED" then
                    local multiplier = 1
                    if buff.bloodtalons:Stacks() > 0 then
                        multiplier = multiplier * 1.3
                    end
                    if buff.tigers_fury:Stacks() > 0 then
                        multiplier = multiplier * 1.15
                    end
                    if harmOrPlates[destGUID] then
                        harmOrPlates[destGUID].RipMultiplier = multiplier
                    end
                elseif eventname == "SPELL_AURA_REFRESH" then
                    if player.prev_gcd == "Rip" or player.prev_gcd == "Primal Wrath" then
                        local multiplier = 1
                        if buff.bloodtalons:Stacks() > 0 then
                            multiplier = multiplier * 1.3
                        end
                        if buff.tigers_fury:Stacks() > 0 then
                            multiplier = multiplier * 1.15
                        end
                        if harmOrPlates[destGUID] then
                            harmOrPlates[destGUID].RipMultiplier = multiplier
                        end
                    end
                elseif eventname == "SPELL_AURA_REMOVED" then
                    if harmOrPlates[destGUID] then
                        harmOrPlates[destGUID].RipMultiplier = 1
                    end
                end
            elseif (eventname == "SPELL_AURA_APPLIED" or eventname == "SPELL_AURA_REFRESH") and (spellName == "Rake" or spellName == "Thrash") then
                local multiplier = 1
                if buff.tigers_fury:Stacks() > 0 then
                    multiplier = multiplier * 1.15
                end
                if harmOrPlates[destGUID] then
                    harmOrPlates[destGUID][spellName.."Multiplier"] = multiplier
                end
            elseif eventname == "SPELL_AURA_REMOVED" then
                --[[if spellName == "Rip" then

                else]]if spellName == "Rake" or spellName == "Thrash" then
                if harmOrPlates[destGUID] then
                    harmOrPlates[destGUID][spellName.."Multiplier"] = 1
                end
            end

            end
        end
    end
    Feral:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    WarGodUnit.spell_targets = spell_targets
end

--WarGodRotations:RegisterForceCast("Regrowth", "player")
WarGodRotations:RegisterForceCast("Swiftmend", "player")
--WarGodRotations:RegisterForceCast("Rebirth", "mouseover")
WarGodRotations:RegisterForceCast("Soothe", "target")
WarGodRotations:RegisterForceCast("Travel Form")
WarGodRotations:RegisterForceCast("Cat Form")
WarGodRotations:RegisterForceCast("Bear Form")
WarGodRotations:RegisterForceCast("Wild Charge")
WarGodRotations:RegisterForceCast("Dash")

WarGodRotations:RegisterForceCast("Maim","target")
--WarGodRotations:RegisterForceCast("Sigil of Silence","player")
--WarGodRotations:RegisterForceCast("Sigil of Chains","cursor")