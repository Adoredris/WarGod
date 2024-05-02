local Druid = WarGod.Class

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local variable = player.variable
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


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
local GetSpellInfo = GetSpellInfo
local GetPowerRegen = GetPowerRegen
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--Delegates = Delegates



do


end

local Feral = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidFeral", "AceConsole-3.0", "AceEvent-3.0")

function player:Setup()
    --print("feral setup")
    variable.finishers = player.combopoints > 3 and (not talent.bloodtalons.enabled) or player.combopoints >= 5 and talent.bloodtalons.enabled
    variable.use_thrash = (azerite.wild_fleshrending.enabled and 2 or 0)

    local multiplier = 1
    if buff.bloodtalons:Stacks() > 0 then
        multiplier = multiplier * 1.25
    end
    if buff.tigers_fury:Stacks() > 0 then
        multiplier = multiplier * 1.15
    end
    variable.multiplier = multiplier
    variable.opener = player:TimeInCombat() < 5 and WarGodUnit.active_enemies < 3 and (WarGodSpells["Tiger's Fury"]:CDRemaining() < 3 or buff.tigers_fury:Stacks() > 0 or buff.bloodtalons:Stacks() > 0)
end

setfenv(1, Rotations)

function Delegates:DotGTCurMultiplier(spell, unit, args)
    local activeMultiplier = unit[spell .. "Multiplier"]
    if (not activeMultiplier) then
        return true
    end
    if variable.multiplier > activeMultiplier * (args and args.multiplierModifier or 1) then
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


    function Feral:COMBAT_LOG_EVENT_UNFILTERED(event)
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if player.guid == sourceGUID then
            if spellName == "Rip" then
                if eventname == "SPELL_AURA_APPLIED" then
                    local multiplier = 1
                    if buff.bloodtalons:Stacks() > 0 then
                        multiplier = multiplier * 1.25
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
                            multiplier = multiplier * 1.25
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
                if buff.bloodtalons:Stacks() > 0 then
                    multiplier = multiplier * 1.25
                end
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
WarGodRotations:RegisterForceCast("Rebirth", "mouseover")
WarGodRotations:RegisterForceCast("Soothe", "target")
WarGodRotations:RegisterForceCast("Travel Form")
WarGodRotations:RegisterForceCast("Cat Form")
WarGodRotations:RegisterForceCast("Bear Form")
WarGodRotations:RegisterForceCast("Wild Charge")
WarGodRotations:RegisterForceCast("Dash")

WarGodRotations:RegisterForceCast("Maim","target")
--WarGodRotations:RegisterForceCast("Sigil of Silence","player")
--WarGodRotations:RegisterForceCast("Sigil of Chains","cursor")