local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite
local charges = player.charges

local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

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
    local baseScore = 6000
    AddSpellFunction("Guardian","Bear Form",baseScore + 999,{
        func = function(self) return buff.bear_form:Stacks() == 0 and
                buff.cat_form:Stacks() == 0 and buff.moonkin_form:Stacks() == 0
        end,
        units = groups.noone,
        label = "Bear"
    })

    AddSpellFunction("Guardian","Moonfire",baseScore + 950,{
        func = function(self)
            return (not WarGodControl:SafeMode())
        end,
        units = groups.targetable,
        label = "Explosive Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.IsExplosive},
    })

    AddSpellFunction("Guardian","Thrash",baseScore + 905, {
        func = function(self)
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and Delegates:UnitInCombat(self.spell, unit, {})
                            and (Delegates:NotHaveThrash(self.spell, unit, {}) or unit.debuff.thrash:Remains() < 1.5) then
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

    AddSpellFunction("Guardian","Frenzied Regeneration",baseScore + 902,{
        func = function(self) return buff.frenzied_regeneration:Stacks() == 0 and (player.health_percent < 0.75 or player.health_percent < 0.75 and Delegates:UnitUnderXPercentHealthPredictedDamage(self.spell, player, {percent = 0.5})) and charges.frenzied_regeneration:Fractional() >= 1.8 and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) and player:TimeInCombat() > 3 end,
        units = groups.noone,
        label = "Regen Low Threshold",
        quick = true,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 10 end,
    })

    AddSpellFunction("Guardian","Thrash",baseScore + 900, {
        func = function(self)
            local reqEnemies = 2
            if --[[WarGodUnit.active_enemies >= reqEnemies and ]]buff.incarnation_guardian_of_ursoc:Up() and buff.incarnation_guardian_of_ursoc:Remains() < 5 then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and Delegates:UnitInCombat(self.spell, unit, {})
                            and Delegates:NotHaveThrash(self.spell, unit, {})
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

    AddSpellFunction("Guardian","Raze",baseScore + 850,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 3 - buff.tooth_and_claw:Stacks()
            if buff.tooth_and_claw:Up() then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and unit:DebuffRemaining("Tooth and Claw","HARMFUL|PLAYER") < 1
                            and Delegates:NotHaveThrash(self.spell, unit, {}) then
                        --print('hello')
                        targets = targets + 1
                        if targets > reqTargets then
                            return true
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Raze (TnC and VC)",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    -- pulverize not obviously tagging, but super high priority when it's really low
    AddSpellFunction("Guardian","Pulverize",baseScore + 800, {
        func = function(self) return player.combat and buff.pulverize:Stacks() > 0 and buff.pulverize:Remains() < 1.5 end,
        units = groups.targetable,
        label = "Pulverize",
        ["andDelegates"] = {Delegates.Pulverizable, Delegates.IsSpellInRange},
        --["scorer"] = MostStacksThrash,
        helpharm = "harm",
        maxRange = 10,
    })

    AddSpellFunction("Guardian","Swipe",baseScore + 700, {
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

    AddSpellFunction("Guardian","Moonfire",baseScore + 600,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Moonfire Tag",
        -- not have aggro and not have thrash and not have moonfire and not in swipe range
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.UnitInCombat, Delegates.NotHaveThrash, Delegates.NotHaveDebuff, Delegates.IAmNotTankingUnit, Delegates.NotInSwipeRange},
        helpharm = "harm",
        maxRange = 40,
    })
end
