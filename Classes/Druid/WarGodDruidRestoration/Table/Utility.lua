local Rotations = WarGod.Rotation

local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite



---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control
--------------------------

setfenv(1, Rotations)




do
    AddSpellFunction("Restoration","Nature's Cure",20000,{
        --func = function(spell, unitid) return LegCore:AutoKick() end,
        ["units"] = groups.targetable,
        label = "Resto Cleanse",
        ["andDelegates"] = {Delegates.HasSpellToCleanse, Delegates.CleanseWrapper},
        --["scorer"] = Delegates.ScoreGenericDispel,
        helpharm = "help",
        maxRange = 40,
        IsUsable = function(self) return player:Mana_Percent() > 0.2 and WarGodControl:AutoCleanse() end,
    })

end
