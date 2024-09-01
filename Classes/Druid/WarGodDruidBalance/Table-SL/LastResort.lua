local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite
local variable = player.variable
local eclipse = player.eclipse
local covenant = player.covenant
local buff_ca_inc = player.buff_ca_inc
local buff_kindred_empowerment_energize = player.buff_kindred_empowerment_energize
local runeforge = player.runeforge
local equipped = player.equipped

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control

local GetShapeshiftForm = GetShapeshiftForm
local GetSpellInfo = C_Spell.GetSpellInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local UnitInRaid = UnitInRaid



local upairs = upairs
local ceil = ceil
local max = max

local print = print

---------TEMP-------------
local WGBM = WarGod.BossMods

local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 0
do
    AddSpellFunction("Balance","Remove Corruption",baseScore + 5,{
        func = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) and buff.ravenous_frenzy:Duration() > 15 end,
        units = groups.player,
        label = "Balance RF Spam Cleanse",
        --["andDelegates"] = {Delegates.IsSpellInRange, Delegates.HasSpellToCleanse, Delegates.CleanseWrapper},

    })

    --[[AddSpellFunction("Balance","Sunfire",baseScore + 1,{
        func = function(self)
            return true
        end,
        units = groups.targetable,
        label = "Sunfire Filler",
        andDelegates = {Delegates.IsSpellInRange, Delegates.UnitIsEnemy},
    })]]

    AddSpellFunction("Balance", "Regrowth",4,{
        -- using stacks because it avoids checking a function
        func = function(self)
            return buff.frenzied_regeneration:Down() and Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.9}) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {}))-- and player:DebuffRemaining("Well-Honed Instincts", "HARMFUL") > 0
        end,
        units = groups.player,
        label = "Regrowth Bored"
    })
end