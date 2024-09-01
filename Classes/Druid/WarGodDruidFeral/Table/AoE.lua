--
-- Created by IntelliJ IDEA.
-- User: Ikevink
-- Date: 16/12/2017
-- Time: 8:00 PM
-- To change this template use File | Settings | File Templates.
--
local WarGod = WarGod
local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local charges = player.charges
local buff = player.buff
local bs_inc = player.bs_inc
local variable = player.variable
local runeforge = player.runeforge
local equipped = player.equipped

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control


local upairs = upairs
local GetSpellInfo = C_Spell.GetSpellInfo
local GetSpecialization = GetSpecialization
local UnitExists = UnitExists
local max = max
local GetItemCount = C_Item.GetItemCount

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodSpells = WarGod.Rotation.rotationFrames["Feral"]

--local Delegates = Rotations.Delegates
--------------------------
WarGod.potion = false

setfenv(1, Rotations)


local baseScore = 6000
do
    AddSpellFunction("Feral","Primal Wrath",baseScore + 900,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
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

    --actions.aoe+=/ferocious_bite,if=buff.apex_predators_craving.up&(!buff.sabertooth.up|(!buff.bloodtalons.stack=1))
    AddSpellFunction("Feral","Ferocious Bite",baseScore + 800,{
        func = function(self)
            if --[[variable.finishers or ]]talent.apex_predators_craving.enabled and buff.apex_predators_craving:Up() then
                return buff.sabertooth:Down() or buff.bloodtalons:Stacks() > 1
            end
        end,
        units = groups.targetable,
        label = "FB (AoE)",

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
        end,x
    })

    AddSpellFunction("Feral","Thrash",baseScore + 700,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then

                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                        if unit:DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and (not Delegates:DotBlacklistedWrapper(self.spell, unit, {})) then
                            numEnemies = numEnemies + 1
                        end

                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
            --end
        end,
        units = groups.noone,
        label = "Thrash (AoE)",
        --IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) or GetShapeshiftForm() == 1 end,
    })

    AddSpellFunction("Feral","Brutal Slash",baseScore + 600,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            if charges.brutal_slash.charges < 1 then return end
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then
                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                        numEnemies = numEnemies + 1
                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Slash (AoE)",
        andDelegates = {Delegates.IsSpellInRange--[[, Delegates.NotDotBlacklistedWrapper]]},
        args = {threshold = 3.6},
    })


    AddSpellFunction("Feral","Rake",baseScore + 500,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            local reqEnemies = 2
            local numEnemies = 0
            if WarGodUnit.active_enemies < reqEnemies then return end
            for guid,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                    numEnemies = numEnemies + 1
                    if numEnemies >= reqEnemies then return true end
                end
            end
        end,
        units = groups.targetable,
        label = "Rake (AoE)",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.NotDotBlacklisted},
        args = {threshold = 3.6},
    })

    AddSpellFunction("Feral","Shred",baseScore + 400,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            local reqEnemies = 2
            local numEnemies = 0
            if WarGodUnit.active_enemies < reqEnemies then return end
            for guid,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                    numEnemies = numEnemies + 1
                    if numEnemies >= reqEnemies then return true end
                end
            end
            return true
        end,
        units = groups.targetable,
        label = "Shred (AoE)",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Feral","Thrash",baseScore + 300,{
        func = function(self)
            if (not WarGodControl:CleaveMode()) and (not WarGodControl:AOEMode()) then
                return
            end
            local reqEnemies = 2
            if WarGodUnit.active_enemies >= reqEnemies then

                local numEnemies = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Rake", unit, {}) and (not Delegates:AoeBlacklistedWrapper(self.spell, unit, {})) then
                        numEnemies = numEnemies + 1

                    end
                    --WarGodUnit:GetTarget():DebuffRemaining("Thrash", "HARMFUL|PLAYER") < 3.6 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget())  and Delegates:NotDotBlacklistedWrapper(self.spell, WarGodUnit:GetTarget())
                end
                if (numEnemies >= reqEnemies) then
                    return true
                end
            end
            --end
        end,
        units = groups.noone,
        label = "Thrash Filler (AoE)",
        --IsUsable = function(self) return GetShapeshiftForm() == 2 and (buff.clearcasting.up or player.energy >= 40) or GetShapeshiftForm() == 1 end,
    })
end