if UnitClass("player") ~= "Paladin" then C_AddOns.DisableAddOn("WarGodPaladinBinds"); return end

local LibStub = LibStub
local Class = WarGod.Class
local Druid = Class

local WarGod = WarGod

local player = WarGod.Unit:GetPlayer()
player.maxHelpRangeSpell = "Flash of Light"
player.maxHarmRangeSpell = "Judgment"