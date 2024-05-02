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
local WarGodSpells = WarGod.Rotation.rotationFrames["Guardian"]
--------------------------


setfenv(1, Rotations)


local function TankingSomething()
    local threat = UnitThreatSituation("player")
    if threat then
        return threat >= 2
    end
end

local function NumThrashesRunning()
    return 1
end

local baseScore = 8000
do

    AddSpellFunction("Guardian","Ironfur",baseScore + 130,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and WGBM:Mitigation(self.spell, WarGodUnit.player, {}) end,
        units = groups.noone,
        label = "Ironfur Bossmods",
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 40 end,
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 125,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and WGBM.default.Mitigation == WGBM.Migiation end,
        units = groups.noone,
        label = "Ironfur Bossmods",
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 40 end,
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 120,{
        func = function(self) return TankingSomething() and buff.ironfur:Remains() < 1 and
                player.rage_deficit <= 9 + (talent.blood_frenzy.enabled and NumThrashesRunning() or 0) end,
        units = groups.noone,
        label = "Ironfur High Rage",
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 110,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and TankingSomething() and
                buff.guardian_of_elune:Stacks() >= 1 and buff.guardian_of_elune:Remains() < 1 end,
        units = groups.noone,
        label = "Ironfur Longer Buff Expiring Soon",
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 100,{
        func = function(self) return player.rage_deficit <= 10 and TankingSomething() end,
        units = groups.noone,
        label = "Ironfur Longer Buff Expiring Soon",
        quick = true,
        offgcd = true,
    })

    AddSpellFunction("Guardian","Frenzied Regeneration",baseScore + 230,{
        func = function(self) return buff.frenzied_regeneration:Stacks() == 0 and (player.health_percent < 0.5 or player.health_percent < 0.3 and Delegates:UnitUnderXPercentHealthPredictedDamage(self.spell, player, {percent = 0.5})) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) end,
        units = groups.noone,
        label = "Regen High Threshold",
    })

    AddSpellFunction("Guardian","Frenzied Regeneration",baseScore + 220,{
        func = function(self) return buff.frenzied_regeneration:Stacks() == 0 and (player.health_percent < 0.75 or player.health_percent < 0.75 and Delegates:UnitUnderXPercentHealthPredictedDamage(self.spell, player, {percent = 0.5})) and charges.frenzied_regeneration:Fractional() >= 1.8 and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) end,
        units = groups.noone,
        label = "Regen Low Threshold",
        quick = true,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 10 end,
    })
end
