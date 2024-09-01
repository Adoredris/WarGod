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


local baseScore = 7000
do
    AddSpellFunction("Feral","Cat Form",baseScore + 999,{
        func = function(self)
            if buff.moonkin_form:Stacks() == 0
                and buff.cat_form:Stacks() == 0
                and buff.bear_form:Stacks() == 0 then
                    return true
            elseif buff.moonkin_form:Stacks() == 1 then
                if player.energy >= 80 and ((not variable.sunfireNeeded) or variable.numBoomyDotsNeeded < 3 and WarGodUnit.active_enemies < 3) then
                    return true
                elseif variable.numBoomyDotsNeeded == 0 then
                    return true
                elseif (not Delegates:DoT_Pandemic("Sunfire", WarGodUnit:GetTarget(), {})) then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Cat"
    })

    AddItemFunction("Feral",13,baseScore + 915, {
        func = function(self)
            if equipped.primal_ritual_shell.slotIndex == 13 then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Rake",unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell,unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then

                if equipped.manic_grieftorch.slotIndex == 13 then
                    if --[[buff.tigers_fury:Remains() > 3 and ]]buff.berserk:Down() then
                        if (not IsMoving()) then
                            return true
                        end

                    end
                elseif equipped.windscar_whetstone.slotIndex == 13 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget()) and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {6, 120}) then
                    --if buff.tigers_fury:Remains() > 6 then
                        return true
                    --end
                end
            end
        end,
        units = groups.noone,
        label = "Trinket Slot 1",
        quick = true,
        IsUsable = function(self) return WarGodControl:AllowCDs() or equipped.manic_grieftorch.slotIndex == 13 end,
    })

    AddItemFunction("Feral",14,baseScore + 910, {
        func = function(self)
            if equipped.primal_ritual_shell.slotIndex == 14 then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Rake",unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell,unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0) then

                if equipped.manic_grieftorch.slotIndex == 14 then
                    if --[[buff.tigers_fury:Remains() > 3 and ]]buff.berserk:Down() then
                        if (not IsMoving()) then
                            return true
                        end

                    end
                elseif equipped.windscar_whetstone.slotIndex == 14 and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget()) and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {6, 120}) then
                    --if buff.tigers_fury:Remains() > 6 then
                        return true
                    --end
                end
            end
        end,
        units = groups.noone,
        label = "Trinket Slot 2",
        quick = true,
        IsUsable = function(self) return WarGodControl:AllowCDs() or equipped.manic_grieftorch.slotIndex == 14 end,
    })

    AddSpellFunction("Feral","Berserk",baseScore + 800,{
        func = function(self) return Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget()) and player.energy >= 30 and (WarGodSpells["Tiger's Fury"]:CDRemaining() > 5 or buff.tigers_fury:Remains() > 10 or WarGodSpells["Tiger's Fury"]:CDRemaining() == 0 or Delegates:BurstUnit("Rake",WarGodUnit:GetTarget(),{})) and (WarGodSpells["Convoke the Spirits"]:CDRemaining() < 10 or WarGodSpells["Convoke the Spirits"]:CDRemaining() > 130)
        end,
        units = groups.noone,
        label = "Berserk",
        IsUsable = function(self) return buff.cat_form:Stacks() > 0
                and WarGodControl:AllowCDs () and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {talent.incarnation_avatar_of_ashamane and 30 or 15, 120})
                and player.combat and WarGodUnit.active_enemies > 0 and buff.berserk:Stacks() < 1 and buff.incarnation_avatar_of_ashamane:Stacks() < 1
        end,
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {"Rake"},
        helpharm = "harm",
        maxRange = 10,
    })

    --actions.cooldowns+=/tigers_fury,if=energy.deficit>=60
    AddSpellFunction("Feral","Tiger's Fury",baseScore + 700,{
        func = function(self)

            --if Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget()) then
                if buff.tigers_fury:Down() and buff.incarnation_avatar_of_ashamane:Up() then
                    return true
                end
                if (player.energy_deficit >= 60 and (buff.tigers_fury:Down() or WarGodUnit.active_enemies > 1) or WarGodUnit.active_enemies > 4 and talent.predator.enabled or buff.bloodtalons:Stacks() > 0 and Delegates:CreatesMaxMultiplier("Rip", WarGodUnit:GetTarget(),{})) then
                    return true
                end
                if (player.energy_deficit >= 60 and talent.predator.enabled) then
                    if buff.moonkin_form:Stacks() > 0 then
                        if Delegates:NotDotBlacklisted("Moonfire", WarGodUnit:GetTarget(), {}) or Delegates:DoT_Pandemic("Moonfire", WarGodUnit:GetTarget(), {}) or Delegates:DoT_Pandemic("Sunfire", WarGodUnit:GetTarget(), {}) then
                            return
                        end
                    end
                    for guid, unit in upairs(groups.targetableOrPlates) do
                        if unit.health_percent < 0.2 then
                            return true
                        end
                    end
                end
            --end
        end,
        units = groups.noone,
        label = "TF",
        IsUsable = function(self)
            if Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget(), {}) then
                return player.combat--(buff.cat_form:Stacks() == 0 and player.combat) or buff.tigers_fury:Stacks() < 1
            end
        end,
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {"Rake"},
        helpharm = "harm",
        maxRange = 10,
        quick = true,
    })

    AddItemFunction("Feral","Fleeting Elemental Potion of Ultimate Power",baseScore + 401,{
        func = function(self)
            if not WarGod.potion then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Rake", unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0)
                    and UnitExists("boss1")-- and (UnitInRaid("player"))
            then
                local zerkRemains = max(buff.berserk:Remains(), buff.incarnation_avatar_of_ashamane:Remains())
                if zerkRemains <= 10 then return end
                return true
            end
        end,
        units = groups.noone,
        label = "Pot",
        quick = true,
        IsUsable = function(self)
            if WarGod.potion and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {25, 300}) and
                    (GetItemCount(191914) > 0 or GetItemCount(191913) > 0 or GetItemCount(191912) > 0 or
                            GetItemCount(191381) > 0 or GetItemCount(191382) > 0 or GetItemCount(191383) > 0) then
                --if DoingHeroicPlus() and GetNumGroupMembers() >= 10 then
                --    return true
                --elseif GetKeyLevel() >= 15 then
                    return true
                --end
            end
        end,
    })

    AddItemFunction("Feral","Fleeting Elemental Potion of Power",baseScore + 400,{
        func = function(self)
            if not WarGod.potion then return end
            local spell, unit, args = self.spell, WarGodUnit:GetTarget(), {}
            if Delegates:UnitIsEnemy("Rake", unit,args)
                    --and (not (not Delegates:DotBlacklistedWrapper(spell, unit,args)))
                    and (not Delegates:DPSBlacklistWrapper(spell, unit,args))
                    and (Delegates:PriorityWrapper(spell, unit,args) > 0)
                    and UnitExists("boss1")-- and (UnitInRaid("player"))
            then
                local zerkRemains = max(buff.berserk:Remains(), buff.incarnation_avatar_of_ashamane:Remains())
                if zerkRemains <= 10 then return end
                return true
            end
        end,
        units = groups.noone,
        label = "Pot",
        quick = true,
        IsUsable = function(self)
            if WarGod.potion and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {25, 300}) and (GetItemCount(191905) > 0 or GetItemCount(191906) > 0 or GetItemCount(191907) > 0
                    or GetItemCount(191389) > 0 or GetItemCount(191388) > 0 or GetItemCount(191387) > 0) then
                --if DoingHeroicPlus() and GetNumGroupMembers() >= 10 then
                --    return true
                --elseif GetKeyLevel() >= 15 then
                return true
                --end
            end
        end,
    })

    AddSpellFunction("Feral","Convoke the Spirits",baseScore + 600,{
        -- using stacks because it avoids checking a function
        func = function(self)
            local tfRemains = buff.tigers_fury:Remains()
            local berserkRemains = buff.berserk:Remains()
            if tfRemains <= 0 then return end
            if tfRemains > 0 and berserkRemains > 0 then
                if tfRemains < 2 and berserkRemains < 6 then
                    return true
                end
            end
            return (player.energy < 80) and (bs_inc:Up() or WarGodSpells["Berserk"]:CDRemaining() > 20) and Delegates:IsSpellInRange("Rake", WarGodUnit:GetTarget()) or buff.moonkin_form:Stacks() > 0 and WarGodUnit.active_enemies > 2
        end,
        units = groups.noone,
        label = "Convoke",
        helpharm = "harm",
        maxRange = 40,
        IsUsable = function(self) return (WarGodControl:AllowCDs () or runeforge.celestial_spirits.equipped) and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, runeforge.celestial_spirits.equipped and 60 or 120}) and player.combat and WarGodUnit.active_enemies > 0 and (GetSpecialization() ~= 1 or buff.moonkin_form:Stacks() > 0) end,
    })

    AddSpellFunction("Feral","Adaptive Swarm",baseScore + 150,{
        func = function(self) return buff.tigers_fury:Up()
        end,
        units = groups.targetable,
        label = "Swarm",
        IsUsable = function(self) return talent.adaptive_swarm.enabled end,
        andDelegates = {Delegates.IsSpellInRange, Delegates.FeralFullyDotted},
        args = {threshold = 7.2, ttd = 10},
        helpharm = "harm",
        maxRange = 15,
    })

    AddSpellFunction("Feral","Feral Frenzy",baseScore + 100,{
        func = function(self) return player.combopoints < 2 or player.combopoints == 2 and buff.incarnation_avatar_of_ashamane:Up()
        end,
        units = groups.targetable,
        label = "Frenzy",
        IsUsable = function(self) return talent.feral_frenzy.enabled and player.energy >= 25 end,
        andDelegates = {Delegates.IsSpellInRange},
        args = {threshold = 7.2, ttd = 10},
        helpharm = "harm",
        maxRange = 15,
    })

    AddSpellFunction("Feral","Nature's Vigil",baseScore + 50,{
        func = function(self) return WGBM.Defensive(self.spell,player, {30, 90})
            --buff.tigers_fury:Up()
        end,
        units = groups.noone,
        label = "Vigil",
        IsUsable = function(self) return talent.natures_vigil.enabled end,
        andDelegates = {Delegates.IsSpellInRange},
        --args = {threshold = 7.2, ttd = 10},
        helpharm = "help",
        maxRange = 15,

    })


end