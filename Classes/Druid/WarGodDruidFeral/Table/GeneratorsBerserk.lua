--
-- Created by IntelliJ IDEA.
-- User: Ikevink
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
local buff_bs_inc = player.bs_inc

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs
local GetShapeshiftForm = GetShapeshiftForm


---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 3000
do
    --[[]]



    AddSpellFunction("Feral","Rake",baseScore + 800,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Down() then return end
            if player.combopoints >= 5 then return end
            return true
        end,
        units = groups.targetable,
        label = "Rake (CD)",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 3.6},
    })

    AddSpellFunction("Feral","Shred",baseScore + 400,{
        func = function(self)
            if buff.incarnation_avatar_of_ashamane:Down() then return end
            if player.combopoints >= 5 then return end
            return true
        end,
        units = groups.targetable,
        label = "Shred (CD)",
        andDelegates = {Delegates.IsSpellInRange},
    })


end