local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local charges = player.charges
local talent = player.trait
local buff = player.buff
local azerite = player.azerite


local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

local upairs = upairs
local select = select
local UnitThreatSituation = UnitThreatSituation
local UnitChannelInfo = UnitChannelInfo
local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange
local UnitAffectingCombat = UnitAffectingCombat
local GetSpellInfo = GetSpellInfo

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]
--------------------------


print("Cat")

setfenv(1, Rotations)


local function TankingSomething()
    local threat = UnitThreatSituation("player")
    if threat then
        return threat >= 2
    end
end

local baseScore = 8700
do
    -- stun logic


    AddSpellFunction("Guardian","Rip",baseScore + 60,{
        func = function(self) return player.combopoints >= 5 and talent.feral_affinity.enabled
        end,
        units = groups.targetable,
        label = "Rip Affinity",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 7.2, ttd = 10},
        helpharm = "harm",
        maxRange = 15,
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and (player.energy >= 20 or player.energy >= 12 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
    })

    AddSpellFunction("Guardian","Ferocious Bite",baseScore + 50,{
        func = function(self) return player.combopoints >= 5 and (player.energy >= 80 or (not talent.feral_affinity.enabled) and player.energy >= 50) end,
        units = groups.targetable,
        label = "FB Affinity",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 15,
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and (player.energy >= 25 or player.energy >= 15 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
    })


    AddSpellFunction("Guardian","Rake",baseScore + 20,{
        func = function(self) return true
        end,
        units = groups.targetable,
        label = "Rake Affinity",
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and (player.energy >= 35 or player.energy >= 21 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 7.2, ttd = 10},
        helpharm = "harm",
        maxRange = 15,
    })

    AddSpellFunction("Guardian","Shred",baseScore + 10,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Shred Affinity",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 15,
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and (buff.clearcasting:Stacks() > 0 or player.energy >= 40 or player.energy >= 24 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
    })
end