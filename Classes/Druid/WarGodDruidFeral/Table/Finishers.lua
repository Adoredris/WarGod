--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local variable = player.variable
local talent = player.trait
local charges = player.charges
local buff = player.buff
local azerite = player.azerite
local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 5000
do
    --actions.finishers=pool_resource,for_next=1
    --actions.finishers+=/savage_roar,if=buff.savage_roar.down





    --actions.finishers+=/pool_resource,for_next=1
    --actions.finishers+=/primal_wrath,target_if=spell_targets.primal_wrath>1&dot.rip.remains<4
    --actions.finishers+=/pool_resource,for_next=1
    --actions.finishers+=/primal_wrath,target_if=spell_targets.primal_wrath>=2
    AddSpellFunction("Feral","Primal Wrath",baseScore + 800,{
        func = function(self)
            if variable.finishers then
                if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                    return
                end
                if WarGodUnit.active_enemies >= 2 then
                    local numTargets = 0
                    local someoneNeedsRip = false
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:HarmIn10Yards(self.spell,unit,{}) and ((not Delegates:DotBlacklistedWrapper(self.spell,unit,{})) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})))  then
                            numTargets = numTargets + 1
                            if unit:DebuffRemaining("Rip","HARMFUL|PLAYER") < 4 then
                                someoneNeedsRip = true
                            end
                            if numTargets >= 2 and someoneNeedsRip == true or numTargets > 2 then
                                return true
                            end
                        end
                    end
                    if numTargets >= 2 and someoneNeedsRip == true or numTargets > 2 then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "AoE Rip",
        IsUsable = function(self) return talent.primal_wrath.enabled and buff.cat_form:Stacks() > 0 and player.combopoints > 0 and (player.energy >= 20 or player.energy >= 12 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
        --andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Exists, Delegates.DoT_Pandemic, Delegates.NoBloodtalonsOrBloodtalonsBuffedRip},
        --args = {aura = "Rip", threshold = 4},
        helpharm = "harm",
        maxRange = 10,
    })

    --actions.finishers+=/pool_resource,for_next=1
    --actions.finishers+=/rip,target_if=!ticking|(remains<=duration*0.3)&(!talent.sabertooth.enabled)|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
    AddSpellFunction("Feral","Rip",baseScore + 790,{
        func = function(self) return variable.finishers
        end,
        units = groups.targetable,
        label = "Rip",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 5.76, ttd = 10},
        helpharm = "harm",
        maxRange = 10,
        quick = true,
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and player.energy >= 20 end,

    })
    --[[AddSpellFunction("Feral","Rip",baseScore + 760,{
        func = function(self)
            if variable.finishers and talent.sabertooth.enabled then

                if ((not talent.primal_wrath.enabled) or WarGodUnit.active_enemies < 3 or buff.bloodtalons:Stacks() > 0) then
                    return true
                else
                    local numUnitsInMelee = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if Delegates:HarmIn10Yards(self.spell, unit, {}) then
                            numUnitsInMelee = numUnitsInMelee + 1
                            if numUnitsInMelee > 2 then
                                return
                            end
                        end
                    end
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Rip",
        andDelegates = {Delegates.IsSpellInRange, Delegates.NotDotBlacklistedWrapper, Delegates.DotGTCurMultiplier},
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and (player.energy >= 20 or player.energy >= 12 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
        args = {threshold = 40, ttd = 10},
        helpharm = "harm",
        maxRange = 10,
        quick = true,
    })]]
    --actions.finishers+=/pool_resource,for_next=1
    --actions.finishers+=/savage_roar,if=buff.savage_roar.remains<12


    --actions.finishers+=/pool_resource,for_next=1
    --actions.finishers+=/maim,if=buff.iron_jaws.up
    --[[AddSpellFunction("Feral","Maim",baseScore + 500,{
        func = function(self) return variable.finishers and buff.iron_jaws:Stacks() > 0
        end,
        units = groups.targetable,
        label = "Maim Iron Jaws",
        IsUsable = function(self) return buff.cat_form:Stacks() > 0 and player.combopoints > 0 and (player.energy >= 30 or player.energy >= 18 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end,
        andDelegates = {Delegates.IsSpellInRange},
        --args = {aura = "Rip", threshold = 3},
        helpharm = "harm",
        maxRange = 10,
    })]]


    --actions.finishers+=/ferocious_bite,max_energy=1
    AddSpellFunction("Feral","Ferocious Bite",baseScore + 450,{
        func = function(self) return variable.finishers or talent.apex_predators_craving.enabled and buff.apex_predators_craving:Up()-- and player.energy >= 25
        end,
        units = groups.targetable,
        label = "FB (Max Energy)",

        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Exists},
        args = {aura = "Rip"},
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self)
            if buff.cat_form:Stacks() > 0 then
                if talent.apex_predators_craving.enabled and buff.apex_predators_craving:Up() then
                    return true
                end
                return player.combopoints > 0 and (player.energy >= 25 or player.energy >= 15 and (buff.berserk:Stacks() > 0 or buff.incarnation_avatar_of_ashamane:Stacks() > 0)) end
        end,
    })



end