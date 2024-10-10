--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 30/06/2017
-- Time: 6:22 PM
-- To change this template use File | Settings | File Templates.
--
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

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodCore = WarGod.Control
--------------------------


setfenv(1, Rotations)

do
    AddSpellFunction("Guardian", "Stampeding Roar",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "SPEED",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "help",
        maxRange = 15,
        --IsUsable = function(self) return talent.wild_charge.enabled end
    })

    AddSpellFunction("Guardian", "Incapacitating Roar",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Disorient",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "help",
        maxRange = 15,
    })



    AddSpellFunction("Guardian", "Bristling Fur",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Bristling",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.bristling_fur.enabled end
    })

end
