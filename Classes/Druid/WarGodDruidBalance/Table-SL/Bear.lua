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

print("Bear")

local function TankingSomething()
    local threat = UnitThreatSituation("player")
    if threat then
        return threat >= 2
    end
end

setfenv(1, Rotations)




local baseScore = 8800
do
    AddSpellFunction("Balance","Frenzied Regeneration",baseScore + 90,{
        func = function(self)
            if not talent.frenzied_regeneration.enabled then return end
            return buff.frenzied_regeneration:Stacks() == 0 and (player.health_percent < 0.5 or player.health_percent < 0.75 and Delegates:UnitUnderXPercentHealthPredictedDamage(self.spell, player, {percent = 0.75})) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {}))
        end,
        units = groups.noone,
        label = "Regen Affinity",
        quick = true,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 10 end,
    })

    AddSpellFunction("Balance","Ironfur",baseScore + 80,{
        func = function(self)
            return player.rage >= 40 and TankingSomething() and (buff.ironfur:Remains() < 0.1 or talent.heart_of_the_wild.enabled and buff.heart_of_the_wild:Up())
        end,
        units = groups.noone,
        label = "Ironfur Affinity",
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 40 end,
    })

    AddSpellFunction("Balance","Mangle",baseScore + 50,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Mangle",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange =15,
        IsUsable = function(self) return --[[talent.guardian_affinity.enabled and  ]]buff.bear_form:Stacks() > 0 end,
    })

    AddSpellFunction("Balance","Thrash",baseScore + 20, {
        func = function(self)
            if not talent.guardian_affinity.enabled then return end
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {})
                        and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {})) then
                    return true
                end
            end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Affinity",
        helpharm = "harm",
        maxRange = 15,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })

end