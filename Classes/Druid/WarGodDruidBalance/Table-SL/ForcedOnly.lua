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
    --[[AddSpellFunction("Balance","Force of Nature",0,{
        func = function(self) return
        end,
        units = groups.cursor,
        label = "FoN",

    })]]

end
