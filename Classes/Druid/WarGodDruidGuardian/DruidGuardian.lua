local Druid = WarGod.Class

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


local min = min
local max = max
local strmatch = strmatch
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local tinsert = tinsert
local tContains = tContains
local WarGodUnit = WarGod.Unit
local harmOrPlates = WarGodUnit.groups.targetableOrPlates

-------------Stuff needed for delegate only---------------
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitPowerMax = UnitPowerMax
local UnitPower = UnitPower
local UnitCastingInfo = UnitCastingInfo
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitClass = UnitClass
local UnitIsUnit = UnitIsUnit
local UnitIsFriend = UnitIsFriend

local WarGodControl = WarGod.Control
local WarGodRotations = WarGod.Rotation

----------------------------------------------------------
local GetTime = GetTime
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetSpellInfo = GetSpellInfo

--Delegates = Delegates



do


end

setfenv(1, Rotations)

function Delegates:StacksLT(spell, unit, args)
    local remains, stacks = unit:AuraRemaining(args and args.aura or spell, "HARMFUL|PLAYER")
    return remains > 0 and stacks < (args and args:Stacks() or 4)
end

do
    player.mana_cost = 0
    player.Mana_Percent = function(self)
        return (self.mana - self.mana_cost) / self.mana_max
    end
    player.Mana = function(self)
        return (self.mana - self.mana_cost)
    end
end


--setmetatable(spell_targets, {__})
do

end

--WarGodRotations:RegisterForceCast("Regrowth", "player")
WarGodRotations:RegisterForceCast("Swiftmend", "player")
WarGodRotations:RegisterForceCast("Rebirth", "mouseover")
WarGodRotations:RegisterForceCast("Soothe", "target")
WarGodRotations:RegisterForceCast("Travel Form")
WarGodRotations:RegisterForceCast("Cat Form")
WarGodRotations:RegisterForceCast("Bear Form")
WarGodRotations:RegisterForceCast("Wild Charge")
WarGodRotations:RegisterForceCast("Dash")

WarGodRotations:RegisterForceCast("Stampeding Roar")
WarGodRotations:RegisterForceCast("Incapacitating Roar")
--WarGodRotations:RegisterForceCast("Sigil of Silence","player")
--WarGodRotations:RegisterForceCast("Sigil of Chains","cursor")

WarGodRotations:RegisterForceCast("Bristling Fur")