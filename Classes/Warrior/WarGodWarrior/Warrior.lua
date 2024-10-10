if UnitClass("player") ~= "Warrior" then C_AddOns.DisableAddOn("WarGodWarrior"); return end
local LibStub = LibStub
local Class = WarGod.Class

local WarGod = WarGod

local player = WarGod.Unit:GetPlayer()
player.maxHelpRangeSpell = "Soulstone"
player.maxHarmRangeSpell = "Shadow Bolt"
local WarGodSpells = WarGod.Rotation.rotationFrames[select(2,GetSpecializationInfo(GetSpecialization()))]
local Rotation = WarGod.Rotation
local Delegates = Rotation.Delegates

local print = print

--player.channels["Convoke the Spirits"] = 4


setfenv(1, Class)

player.mana_cost = 0
player.Mana_Percent = function(self)
    return (self.mana - self.mana_cost) / self.mana_max
end
player.Mana = function(self)
    return (self.mana - self.mana_cost)
end
