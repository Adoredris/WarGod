local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local buff = player.buff
local covenant = player.covenant
local talent = player.trait

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
--------------------------


setfenv(1, Rotations)

function Delegates:Moonfire_Refresh(spell, unit)
    return unit:DebuffRemaining(spell, "HARMFUL|PLAYER") < 4.8
end

do
    local baseScore = 5000
    AddSpellFunction("Guardian","Bear Form",baseScore + 999,{
        func = function(self) return buff.bear_form:Stacks() == 0 and
                buff.cat_form:Stacks() == 0 and buff.moonkin_form:Stacks() == 0
        end,
        units = groups.noone,
        label = "Bear"
    })

    AddSpellFunction("Guardian","Maul",baseScore + 895,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 3 - buff.tooth_and_claw:Stacks()
            if buff.tooth_and_claw:Up() and buff.vicious_cycle:Stacks() >= 3 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) and unit:DebuffRemaining("Tooth and Claw","HARMFUL|PLAYER") < 1 then
                        targets = targets + 1
                        if targets > reqTargets then
                            return true
                        end
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Maul",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Thrash",baseScore + 890, {
        func = function(self)
            local reqEnemies = 3
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {})
                        and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {}))
                        and (Delegates:DoT_Pandemic("Thrash", unit, {threshold = 1.5}) or Delegates:StacksLT("Thrash", unit, {stacks = 3})--[[ or runeforge.ursocs_fury_remembered.equipped]]) then
                    immoTargets = immoTargets + 1
                    --return true
                    if immoTargets >= reqEnemies then
                        return true
                    end
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Stacks (Many AoE)",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self)
            if SpellCDRemaining(77758) < 0.3 and buff.bear_form:Stacks() > 0 then return true end
        end,
        --[[CDRemaining = function(self)
            local t = GetSpellCooldown(77758) or {}
            print(t)
            --decided non-existant spells should never pretend to be off cd, so now they don't.. fix any bugs that result
            if(t.startTime==nil)then
                t.startTime=GetTime() + 1337 --0;
                t.duration=1337 -- 0;
            end
            return t.startTime+t.duration-GetTime();
        end,]]

    })

    AddSpellFunction("Guardian","Raze",baseScore + 885,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 3 - buff.tooth_and_claw:Stacks()
            if buff.tooth_and_claw:Up() and buff.vicious_cycle:Stacks() >= 1 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) and unit:DebuffRemaining("Tooth and Claw","HARMFUL|PLAYER") < 1 then
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

    AddSpellFunction("Guardian","Lunar Beam",baseScore + 880,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            local reqTargets = 1
            local targets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {}) then
                    --print('hello')
                    targets = targets + 1
                    if targets > reqTargets then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Lunar Beam",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and talent.lunar_beam.enabled end,
    })

    AddSpellFunction("Guardian","Moonfire",baseScore + 860,{
        func = function(self) return WarGodUnit.active_enemies < 3 and buff.incarnation_guardian_of_ursoc.up end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        helpharm = "harm",
        maxRange = 40,
    })

    AddSpellFunction("Guardian","Raze",baseScore + 855,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if not talent.raze.enabled then return end
            local reqTargets = 1
            if buff.vicious_cycle:Stacks() >= 3 then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
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
        label = "Raze (Max VC)",
        --andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Guardian","Thrash",baseScore + 850, {
        func = function(self)
            local reqEnemies = 1
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            if buff.incarnation_guardian_of_ursoc.up then
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {}))
                            and (Delegates:DoT_Pandemic("Thrash", unit, {threshold = 1.5}) or Delegates:StacksLT("Thrash", unit, {stacks = 3})--[[ or runeforge.ursocs_fury_remembered.equipped]]) then
                        immoTargets = immoTargets + 1
                        --return true
                        if immoTargets >= reqEnemies then
                            return true
                        end
                    end
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Stacks (Incarn)",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })


    AddSpellFunction("Guardian","Mangle",baseScore + 800,{
        func = function(self) return (buff.incarnation_guardian_of_ursoc:Up() or buff.berserk:Up()) and WarGodUnit.active_enemies < 3 end,
        units = groups.targetable,
        label = "Incarn Mangle No AOE",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })

    AddSpellFunction("Guardian","Thrash",baseScore + 700, {
        func = function(self)
            local reqEnemies = 2
            --if WarGodUnit.active_enemies >= reqEnemies then
                local immoTargets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {})
                            and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {})) then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
                return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,--groups.targetableOrPlates,
        label = "Thrash Spam",
        --["andDelegates"] = {Delegates:UnitInCombat, Delegates:NotHaveThrash}, -- hopefully the combat check removes units that can't be cleaved
        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 10,
    })

    -- this one was for when
    --[[AddSpellFunction("Guardian","Mangle",6650,{
        func = function(self) return (buff.incarnation_guardian_of_ursoc.up or buff.berserk.up) end,
        units = groups.targetable,
        label = "Incarn Mangle",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
    })]]

        AddSpellFunction("Guardian","Moonfire",baseScore + 600,{
            func = function(self) return buff.galactic_guardian:Remains() < 2 and buff.galactic_guardian:Up() end,
            units = groups.targetable,
            label = "ST GG Moonfire",
            helpharm = "harm",
            maxRange = 30,
            andDelegates = {Delegates.IsSpellInRange},
        })


    AddSpellFunction("Guardian","Mangle",baseScore + 500,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "ST Mangle",
        andDelegates = {Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 8,
    })

    AddSpellFunction("Guardian","Moonfire",baseScore + 400,{
        func = function(self) return WarGodUnit.active_enemies < 3 end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        helpharm = "harm",
        maxRange = 40,
    })

    --[[AddSpellFunction("Guardian","Moonfire",6200,{
        func = function(self) return buff.galactic_guardian:Up() end,
        units = groups.targetable,
        label = "ST GG Moonfire"
    })]]

    AddSpellFunction("Guardian","Pulverize",baseScore + 200, {
        func = function(self) return player.combat and buff.pulverize:Remains() < 3.5 end,
        units = groups.targetable,
        label = "Pulverize",
        andDelegates = {Delegates.Pulverizable, Delegates.IsSpellInRange},
        --["scorer"] = MostStacksThrash,

        --["scorer"] = WarGodUnit.DebuffRemaining,
        helpharm = "harm",
        maxRange = 8,
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and talent.pulverize.enabled end,
    })

    AddSpellFunction("Guardian","Raze",baseScore + 195,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if (threat == nil or threat < 3) and player.rage_deficit <= 15 or buff.tooth_and_claw:Up() then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
                        targets = targets + 1
                        if targets > 1 then
                            return true
                        end
                    end
                end
                if (targets < 2) then
                    return
                end
            end
        end,
        units = groups.targetable,
        label = "noone",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and (player.rage >= 40 or buff.tooth_and_claw:Up())  end,
        helpharm = "harm",
        maxRange = 8,
    })

    AddSpellFunction("Guardian","Maul",baseScore + 150,{
        func = function(self)
            local threat = UnitThreatSituation("player")
            if (threat == nil or threat < 3) and player.rage_deficit <= 15 or buff.tooth_and_claw:Up() then
                local targets = 0
                for k,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Mangle", unit, {}) then
                        targets = targets + 1
                        if targets > 2 then
                            return player.rage_deficit <= 5
                        end
                    end
                end
                if (targets <= 2) then
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Maul",
        andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and (player.rage >= 40 or buff.tooth_and_claw:Up())  end,
        helpharm = "harm",
        maxRange = 8,
    })

    --[[AddSpellFunction("Guardian","Maul",1900,{
        func = function(self)
            local threat = UnitThreatSituation("player");
            if (threat == nil or threat <= 1) and player.rage_deficit <= 5 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Maul",
        ["andDelegates"] = {Delegates.IsSpellInRange},
        IsUsable = function(self) return player.rage >= 45 end,
        helpharm = "harm",
        maxRange = 8,
    })]]

    AddSpellFunction("Guardian","Moonfire",baseScore + 100,{
        func = function(self) return WarGodUnit.active_enemies < 4 end,
        units = groups.targetable,
        label = "Refresh Low Targets Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
    })

    AddSpellFunction("Guardian","Swipe",baseScore + 50, {
        func = function(self)
            local reqEnemies = 2
            --if WarGodUnit.active_enemies >= reqEnemies then
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mangle", unit, {})
                        --and Delegates:UnitInCombat(self.spell, unit, {})
                        and (not Delegates:DotBlacklistedWrapper("Mangle", unit, {})) then
                    immoTargets = immoTargets + 1
                    return true
                end
            end
            return immoTargets >= reqEnemies
            --end
        end,
        units = groups.noone,
        label = "Swipe",
        andDelegates = {Delegates.UnitInCombat},
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 end,
    })


    AddSpellFunction("Guardian","Moonfire",baseScore + 25,{
        --func = function(self) return buff.galactic_guardian:Up() end,
        units = groups.targetable,
        label = "Refresh AOE Moonfire",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic},
        args = {threshold = 4.8},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 or buff.bear_form:Stacks() > 0 and player.spec == "Guardian" or buff.cat_form:Stacks() > 0 and talent.lunar_inspiration.enabled and player.energy >= 30 end,
    })
end
