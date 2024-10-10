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

do

    AddSpellFunction(nil,"Mind Freeze",20000,{
        func = function(self) return WarGodControl:AutoKick() end,
        units = groups.targetable,
        label = "Bear Kick",
        ["andDelegates"] = {--[[Delegates.HasSpellToInterrupt, ]]Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        ["args"] = {kick = true},
        helpharm = "harm",
        maxRange = 10,
    })
end
