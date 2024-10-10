if UnitClass("player") ~= "Death Knight" then C_AddOns.DisableAddOn("WarGodDeathKnightBinds"); return end

local LibStub = LibStub
local Class = WarGod.Class
local Druid = Class

local WarGod = WarGod

local player = WarGod.Unit:GetPlayer()
player.maxHelpRangeSpell = "Raise Ally"
player.maxHarmRangeSpell = "Death Grip"