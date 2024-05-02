local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

local upairs = upairs
local select = select
local UnitThreatSituation = UnitThreatSituation
local UnitChannelInfo = UnitChannelInfo
local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange
local UnitAffectingCombat = UnitAffectingCombat
local GetShapeshiftForm = GetShapeshiftForm

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
--------------------------


setfenv(1, Rotations)
do
    local baseScore = 0
    AddSpellFunction("Guardian","Moonfire",200, {
        units = groups.targetable,
        label = "Last Resort Moonfire TANK",
        ["andDelegates"] = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Remove Corruption",baseScore + 5,{
        func = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 1 or GetShapeshiftForm() == nil) and buff.ravenous_frenzy:Duration() > 15 end,
        units = groups.player,
        label = "Guardian RF Spam Cleanse",
        --["andDelegates"] = {Delegates.IsSpellInRange, Delegates.HasSpellToCleanse, Delegates.CleanseWrapper},

    })
end
