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

    AddSpellFunction("Feral","Maim",0,{
        func = function(self) return
        end,
        units = groups.targetable,
        label = "Maim Force",
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and player.energy >= 30 end,
        andDelegates = {Delegates.IsSpellInRange},
        --args = {aura = "Rip", threshold = 3},
        helpharm = "harm",
        maxRange = 10,
    })


    AddSpellFunction("Feral","Dash",0,{
        func = function(self) return
        end,
        units = groups.noone,
        label = "Dash",
        IsUsable = function(self) return buff.dash:Down() end,
        andDelegates = {Delegates.IsSpellInRange},
        --args = {aura = "Rip", threshold = 3},
        helpharm = "help",
        maxRange = 10,
    })
end
