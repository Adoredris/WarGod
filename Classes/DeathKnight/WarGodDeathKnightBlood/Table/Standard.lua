local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local buff = player.buff
local talent = player.trait
local charges = player.charges

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
local WarGodSpells = WarGod.Rotation.rotationFrames["Blood"]
--------------------------


setfenv(1, Rotations)


do
    local baseScore = 3000

    AddSpellFunction("Blood","Death Strike",3990,{
        func = function(self) return player.health_percent < 0.5
        end,
        units = groups.targetable,
        label = "Death Strike",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
    })

    AddSpellFunction("Blood","Marrowrend",3875,{
        func = function(self)
            if buff.bone_shield:Stacks() < 4 then
                local runeWeaponRemains = buff.dancing_rune_weapon:Remains()
                if runeWeaponRemains > 0 and runeWeaponRemains < player.gcd * 3 then
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Marrowrend",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 5,
        IsUsable = function(self) return player.runes >= 2 end
    })

    AddSpellFunction("Blood","Empower Rune Weapon",3850,{
        func = function(self)
            if player.runes_deficit > 2 then return end
            local reqTargets = 1
            if WarGodUnit.active_enemies >= reqTargets  then
                local numTargets = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:IsSpellInRange("Death Strike",unit,{}) then
                        numTargets = numTargets + 1
                        return true
                    end
                    if numTargets >= reqTargets then
                        return true
                    end
                end
            end
        end,
        units = groups.noone,
        label = "Empower Rune Weapon",
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.empower_rune_weapon.enabled and player.combat and WarGodUnit.active_enemies > 0 and WarGodControl:AllowCDs() end,
    })

    AddSpellFunction("Blood","Dancing Rune Weapon",3825,{
        func = function(self)
            --[[local reqTargets = 1
            if WarGodUnit.active_enemies >= reqTargets  then
                local numTargets = 0
                for guid,unit in upairs(groups.targetableOrPlates) do
                    if Delegates:HarmIn8Yards(self.spell,unit,{}) then
                        numTargets = numTargets + 1
                        return true
                    end
                end
                if numTargets >= reqTargets then
                    return true
                end
            end]]
            return true
        end,
        units = groups.targetable,
        label = "Dancing Rune Weapon",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.dancing_rune_weapon.enabled and WarGodControl:AllowCDs() end,
    })

    AddSpellFunction("Blood","Death's Caress",3800,{
        func = function(self) return --[[buff.bone_shield:Stacks() == 0 or ]]buff.bone_shield:Remains() < 3
        end,
        units = groups.targetable,
        label = "Deaths' Caress",
        ["andDelegates"] = {Delegates.UnitIsEnemy, },
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return talent.deaths_caress.enabled end,
    })

    AddSpellFunction("Blood","Death and Decay",baseScore + 3750,{
        func = function(self)
            if player.prev_gcd == "Death and Decay" or player.prev_prev_gcd == "Death and Decay" then return end
            if talent.cleaving_strikes.enabled and buff.death_and_decay:Remains() == 0 or (not talent.cleaving_strikes.enabled) then
                local reqTargets = 1
                if WarGodUnit.active_enemies >= reqTargets  then
                    local numTargets = 0
                    for guid,unit in upairs(groups.targetableOrPlates) do
                        if IsMoving() and Delegates:IsSpellInRange("Death Strike",unit,{}) or Delegates:IsSpellInRange("Mind Freeze",unit,{}) then
                            numTargets = numTargets + 1
                            return true
                        end
                    end
                    if numTargets >= reqTargets then
                        return true
                    end
                end
            end
        end,
        units = groups.player,
        label = "DnD",
        helpharm = "harm",
        maxRange = 30,
        IsUsable = function(self) return player.combat and WarGodUnit.active_enemies > 0 and (player.runes >= 1 or talent.crimson_scrouge.enabled and buff.crimson_scourge:Up()) and (WarGodControl:AllowClickies() or charges.death_and_decay:Fractional() > 1.9 or player:TimeInCombat() < 3) end,
    })

    AddSpellFunction("Blood","Marrowrend",3725,{
        func = function(self)
            if buff.bone_shield:Stacks() < 3 then
                local runeWeaponRemains = buff.dancing_rune_weapon:Remains()
                if runeWeaponRemains == 0 and (WarGodSpells["Dancing Rune Weapon"]:CDRemaining() > 5 or (not WarGodControl:AllowCDs())) then
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Marrowrend",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
    })

    AddSpellFunction("Blood","Death's Caress",3700,{
        func = function(self) return buff.bone_shield:Stacks() < 5
        end,
        units = groups.targetable,
        label = "Death's Caress",
        andDelegates = {Delegates.UnitIsEnemy, },
        helpharm = "harm",
        maxRange = 30,
    })

    AddSpellFunction("Blood","Raise Dead",3650,{
        func = function(self) return talent.raise_dead.enabled and (not UnitExists("pet"))
        end,
        units = groups.noone,
        label = "Raise Dead",
        helpharm = "harm",
        IsUsable = function(self) return player.combat and WarGodUnit.active_enemies > 0 end,
    })

    -- Dancing Rune Weapon

    AddSpellFunction("Blood","Blood Boil",3600,{
        func = function(self)
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mind Freeze", unit, {itemId = 8149}) then

                    if charges.blood_boil:Fractional() > 1.8 then
                        return true
                    end
                    if unit:DebuffRemaining("Blood Plague","HARMFUL|PLAYER") < player.gcd then
                        immoTargets = immoTargets + 1
                        return true
                    end
                end
            end
            return immoTargets > 0
        end,
        units = groups.noone,
        label = "Blood Boil",
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {spell = "Disrupt"},
        helpharm = "harm",
        maxRange = 10,
        IsUsable = function(self) return talent.blood_boil.enabled and player.combat and WarGodUnit.active_enemies > 0  end,
    })

    AddSpellFunction("Blood","Tombstone",3550,{
        func = function(self) return buff.bone_shield:Stacks() >= 5 and buff.death_and_decay:Up()
        end,
        units = groups.noone,
        label = "Tombstone",
        --["andDelegates"] = {Delegates.IsSpellInRange},
        --args = {spell = "Shear", aura = "Frailty", threshold = 6},
        helpharm = "harm",
        maxRange = 5,
        IsUsable = function(self) return talent.tombstone.enabled end
    })

    AddSpellFunction("Blood","Death Strike",3490,{
        func = function(self) return player.runicpower >= 75 or (talent.icy_talons.enabled and buff.icy_talons:Remains() < player.gcd * 2)
        end,
        units = groups.targetable,
        label = "Death Strike",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 5,
        IsUsable = function(self) return player.runicpower >= 40 end
    })

    AddSpellFunction("Blood","Blood Boil",3450,{
        func = function(self)
            local immoTargets = 0
            for k,unit in upairs(groups.targetableOrPlates) do
                if Delegates:IsSpellInRange("Mind Freeze", unit, {itemId = 8149}) then

                    if charges.blood_boil:Fractional() > 1.8 then
                        return true
                    end
                end
            end
            return immoTargets > 0
        end,
        units = groups.noone,
        label = "Blood Boil",
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {spell = "Disrupt"},
    })

    AddSpellFunction("Blood","Heart Strike",3400,{
        func = function(self) return player.runes > 3 or player.runes == 3 and player.TimeTillNextRune() < 1.5
        end,
        units = groups.targetable,
        label = "Heart Strike",
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 5,
        IsUsable = function(self) return player.runes >= 1 end
    })

    AddSpellFunction("Blood","Blood Tap",3100,{
        func = function(self) return player.runes_deficit > 3
        end,
        units = groups.noone,
        label = "Tap",
        --andDelegates = {Delegates.IsSpellInRange},
        IsUsable = function(self) return talent.blood_tap.enabled and player.runes_deficit > 1 end
    })

    AddSpellFunction("Blood","Death's Caress",3050,{
        func = function(self) return true
        end,
        units = groups.targetable,
        label = "Deaths' Caress",
        --["andDelegates"] = {},
        helpharm = "harm",
        maxRange = 30,
    })
end
