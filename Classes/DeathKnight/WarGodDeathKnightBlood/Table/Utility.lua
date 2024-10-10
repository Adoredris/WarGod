local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite

local WarGodControl = WarGod.Control

local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

local upairs = upairs
local select = select
local UnitThreatSituation = UnitThreatSituation
local UnitChannelInfo = UnitChannelInfo
local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange
local UnitAffectingCombat = UnitAffectingCombat
local GetShapeshiftForm = GetShapeshiftForm
local GetSpellInfo = C_Spell.GetSpellInfo

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodSpells = WarGod.Rotation.rotationFrames["Blood"]
--------------------------




setfenv(1, Rotations)



function Delegates:NotHaveDebuff(spell, unit)
    return unit:DebuffRemaining(spell, "HARMFUL|PLAYER") == 0
end

function Delegates:NotHaveThrash(spell, unit)
    return unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER") == 0
end

--[[function Delegates:NotHaveThrash(spell, unitid)
    return WarGodUnit:DebuffRemaining("Thrash", unitid) == 0
end]]

function Delegates:Pulverizable(spell, unit)
    local remains, stacks = unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER")
    return stacks >= 2
end

function Delegates:IAmNotTankingUnit(spell, unit)
    local threat = UnitThreatSituation("player", unit.unitid)
    if (threat == nil or threat < 2) then
        return true
    end
end

function Delegates:NotInSwipeRange(spell, unit)
    return IsSpellInRange("Mangle", unit.unitid) ~= 1
end

function Delegates:BreakChannelWithCC(spell, unit)
    return UnitChannelInfo(unit.unitid) == "Nether Storm"
end

do

    AddSpellFunction("Blood","Tombstone",16122, {
        func = function(self) return Delegates:DefensiveWrapper(self.spell,player, {12, 60}) and buff.bone_shield:Stacks() >= 5 end,
        units = groups.noone,
        label = "Tombstone WGBM",
        helpharm = "help",
        offgcd = true
    })

    AddSpellFunction("Blood","Dark Command",25000,{
        --func = function(self) return buff.bear_form:Stacks() == 0 end,
        units = groups.targetable,
        label = "Taunt",
        ["andDelegates"] = {Delegates.IAmNotTankingUnit, Delegates.TauntWrapper},
        helpharm = "harm",
        maxRange = 30,
    })

    --[[AddSpellFunction("Blood","Incapacitating Roar",24900,{
        --func = function(self) return buff.bear_form:Stacks() == 0 end,
        units = groups.noone,
        label = "BreakChannelWithCC",
        ["andDelegates"] = {Delegates.BreakChannelWithCC},
    })]]
end
