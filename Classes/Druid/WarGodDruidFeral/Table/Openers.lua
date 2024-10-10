--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local charges = player.charges
local buff = player.buff
local azerite = player.azerite
local variable = player.variable

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs
local GetShapeshiftForm = GetShapeshiftForm
local IsUsableSpell = IsUsableSpell
local GetNumGroupMembers = GetNumGroupMembers

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 9000
do

    --[[AddSpellFunction("Feral","Tiger's Fury",baseScore + 900,{
        func = function(self) return variable.opener and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())
        end,
        units = groups.noone,
        label = "TF Open",
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and buff.tigers_fury:Stacks() < 1 end,
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {"Rake"},
        helpharm = "harm",
        maxRange = 10,
        quick = true,
    })]]

    AddSpellFunction("Feral","Prowl",baseScore + 900,{
        func = function(self) return GetShapeshiftForm() == 2 and ((not player.combat) or GetNumGroupMembers() > 2)
        end,
        units = groups.noone,
        label = "Stealth",
        --andDelegates = {Delegates.IsSpellInRange--[[, Delegates.NotDotBlacklistedWrapper]]},
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return buff.prowl:Stacks() == 0 and buff.shadowmeld:Stacks() == 0 and IsUsableSpell("Prowl") end,
    })

    AddSpellFunction("Feral","Rake",baseScore + 800,{
        func = function(self) return variable.opener and (buff.prowl:Stacks() > 0 or buff.shadowmeld:Stacks() > 0)
        end,
        units = groups.targetable,
        label = "Rake (Stealthed Open)",
        andDelegates = {Delegates.IsSpellInRange--[[, Delegates.NotDotBlacklistedWrapper]]},
        helpharm = "harm",
        maxRange = 10,
    })

    --[[AddSpellFunction("Feral","Rip",baseScore + 700,{
        func = function(self) return variable.opener and player.combopoints > 0
        end,
        units = groups.targetable,
        label = "Rip Open",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Missing, Delegates.NotDotBlacklistedWrapper},
        args = {threshold = 5.76, ttd = 10},
        helpharm = "harm",
        maxRange = 10,
        quick = true,
    })]]


    --actions.generators+=/pool_resource,for_next=1
    --actions.generators+=/rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
    --[[AddSpellFunction("Feral","Rake",baseScore + 600,{
        func = function(self)
            return variable.opener
        end,
        units = groups.targetable,
        label = "Rake Open",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Missing},
        args = {threshold = 3.6},
        quick = true,
    })]]

end