local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
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

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
--------------------------


setfenv(1, Rotations)

-----------------------Base ------------------------------
do
    AddSpellFunction("Guardian","Moonfire",6950,{
        func = function(self)
            return (not WarGodControl:SafeMode())
        end,
        units = groups.targetable,
        label = "Explosive Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.IsExplosive},
    })

    AddSpellFunction("Guardian","Thrash",6905, {
        func = function(self)
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and Delegates:UnitInCombat(self.spell, unit, {})
                            and Delegates:NotHaveThrash(self.spell, unit, {}) then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
                return immoTargets >= reqEnemies
            end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Tag",
        --["andDelegates"] = {Delegates.UnitInCombat, Delegates.NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })

    AddSpellFunction("Guardian","Thrash",6900, {
        func = function(self)
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies and buff.incarnation_guardian_of_ursoc:Up() and buff.incarnation_guardian_of_ursoc:Remains() < 5 then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and Delegates:UnitInCombat(self.spell, unit, {})
                            --[[and Delegates:NotHaveThrash(self.spell, unit, {}) ]]then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
                return immoTargets >= reqEnemies
            end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Tag",
        --["andDelegates"] = {Delegates.UnitInCombat, Delegates.NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })

    -- pulverize not obviously tagging, but super high priority when it's really low
    AddSpellFunction("Guardian","Pulverize",6800, {
        func = function(self) return player.combat and buff.pulverize:Stacks() > 0 and buff.pulverize:Remains() < 1.5 end,
        units = groups.targetable,
        label = "Pulverize",
        ["andDelegates"] = {Delegates.Pulverizable, Delegates.IsSpellInRange},
        --["scorer"] = MostStacksThrash,
        helpharm = "harm",
        maxRange = 10,
    })

    AddSpellFunction("Guardian","Swipe",6700, {
        func = function(self)
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and Delegates:UnitInCombat(self.spell, unit, {})
                            and Delegates:NotHaveThrash(self.spell, unit, {})
                            and Delegates:IAmNotTankingUnit(self.spell, unit, {}) then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
                return immoTargets >= reqEnemies
            end
        end,
        units = groups.noone,
        label = "Swipe Tag",
        --["andDelegates"] = {Delegates.UnitInCombat, Delegates.NotHaveThrash, Delegates.IAmNotTankingUnit}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })

    AddSpellFunction("Guardian","Moonfire",6600,{
        --func = function(self) return buff.galactic_guardian:Up() end,
        units = groups.targetable,
        label = "Moonfire Tag",
        -- not have aggro and not have thrash and not have moonfire and not in swipe range
        ["andDelegates"] = {Delegates.UnitInCombat, Delegates.NotHaveThrash, Delegates.NotHaveDebuff, Delegates.IAmNotTankingUnit, Delegates.NotInSwipeRange},
        helpharm = "harm",
        maxRange = 40,
    })
end
