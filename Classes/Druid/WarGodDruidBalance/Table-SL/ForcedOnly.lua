--
-- Created by IntelliJ IDEA.
-- User: Ikevink
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
    --[[AddSpellFunction("Balance", "Wild Charge",0,{
        func = function(self)  end,       -- dummy func, don't do it
        units = groups.noone,
        label = "Wild Charge",
        --["andDelegates"] = {Delegates.HasSpellToInterrupt_LatestPossibleInterrupt, Delegates.InterruptWrapper, Delegates.IsSpellInRange},
        --isCC = true,
        helpharm = "help",
        --maxRange = 10,
        IsUsable = function(self) return talent.wild_charge.enabled end
    })]]

end
