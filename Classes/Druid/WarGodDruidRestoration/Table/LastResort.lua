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

    AddSpellFunction("Restoration","Moonfire",300, {
        func = function(self) return player:Mana_Percent() > 0.5 end,
        ["units"] = groups.targetable,
        label = "LR Moonfire RESTO",
        ["andDelegates"] = {Delegates.DoT_Pandemic},
        args = {threshold = 6.6},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        helpharm = "harm",
        maxRange = 40,

    })

    AddSpellFunction("Restoration","Sunfire",200, {
        func = function(self) return player:Mana_Percent() > 0.5 end,
        ["units"] = groups.targetable,
        label = "LR Sunfire RESTO",
        ["andDelegates"] = {Delegates.DoT_Pandemic},
        args = {threshold = 5.4},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        helpharm = "harm",
        maxRange = 40,
    })

    AddSpellFunction("Restoration","Wrath",100, {
        --func = function(self) return player.mana_percent > 0.95 end,
        ["units"] = groups.targetable,
        label = "LR Wrath RESTO",
        helpharm = "harm",
        maxRange = 40,
        Castable = function(self) return (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
    })

end
