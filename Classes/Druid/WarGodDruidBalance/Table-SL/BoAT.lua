local WGBM = WarGod.BossMods

local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local buffNotMine = player.buffNotMine
local variable = player.variable
local eclipse = player.eclipse
local covenant = player.covenant
local conduit = player.conduit
local buff_ca_inc = player.buff_ca_inc
local buff_kindred_empowerment_energize = player.buff_kindred_empowerment_energize
local runeforge = player.runeforge
local equipped = player.equipped

local WarGodUnit = WarGod.Unit
local WarGodControl = WarGod.Control

local GetShapeshiftForm = GetShapeshiftForm
local GetSpellInfo = C_Spell.GetSpellInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellCount = C_Spell.GetSpellCastCount
local GetInventoryItemCooldown = GetInventoryItemCooldown



local upairs = upairs
local ceil = ceil

local print = print


---------TEMP-------------
local WGBM = WarGod.BossMods

local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]

--local Delegates = Rotations.Delegates
--------------------------

setfenv(1, Rotations)


local baseScore = 3000
do
    --actions.boat=ravenous_frenzy,if=buff.ca_inc.remains>15
    --[[AddSpellFunction("Balance","Ravenous Frenzy",baseScore + 999,{
        -- using stacks because it avoids checking a function
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return
            buff_ca_inc:Remains() > 15
        end,
        units = groups.noone,
        label = "RF BoAT",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        offgcd = true,
        --Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        --IsUsable = function(self) return (WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {20, 180}) or buff_ca_inc:Up()) and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })]]

    --actions.boat+=/celestial_alignment,if=variable.cd_condition&(astral_power>90&(buff.kindred_empowerment_energize.up|!covenant.kyrian)|covenant.night_fae|buff.bloodlust.up&buff.bloodlust.remains<20+(conduit.precise_alignment.time_value))&(variable.convoke_desync|cooldown.convoke_the_spirits.ready)|interpolated_fight_remains<20+(conduit.precise_alignment.time_value)
    --actions.boat+=/incarnation,if=variable.cd_condition&(astral_power>90&(buff.kindred_empowerment_energize.up|!covenant.kyrian)|covenant.night_fae|buff.bloodlust.up&buff.bloodlust.remains<30+(conduit.precise_alignment.time_value))&(variable.convoke_desync|cooldown.convoke_the_spirits.ready)|interpolated_fight_remains<30+(conduit.precise_alignment.time_value)
    AddSpellFunction("Balance","Celestial Alignment",baseScore + 998,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            local lustRemains = LustRemaining()
            --variable.cd_condition&(astral_power>90&(buff.kindred_empowerment_energize.up|!covenant.kyrian)|covenant.night_fae|buff.bloodlust.up&buff.bloodlust.remains<20+(conduit.precise_alignment.time_value))&(variable.convoke_desync|cooldown.convoke_the_spirits.ready)|interpolated_fight_remains<20+(conduit.precise_alignment.time_value)
            if buffNotMine.kindred_empowerment.up
                    or (not equipped.empyreal_ordnance.equipped) or (buff.empyreal_surge.up or WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() > 60 and WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() < 150) then
                if variable.cd_condition and --[[((player:Lunar_Power() >= 90 or buffNotMine.kindred_empowerment.up) and (buff.kindred_empowerment:Up() or (not covenant.kyrian))]] covenant.night_fae and (WarGodSpells["Convoke the Spirits"]:CDRemaining() < player.gcd) or (not covenant.night_fae)  --[[|interpolated_fight_remains<(talent.incarnation_chosen_of_elune.enabled and 30 or 20)+(conduit.precise_alignment.time_value)]]
                then
                    local empOrdSlot = equipped.empyreal_ordnance.slotIndex
                    local bellSlot = empOrdSlot == 13 and 14 or 13
                    local _, trinket2ready = GetInventoryItemCooldown("player",bellSlot)
                    if trinket2ready == 0 then
                        return true
                    end
                end
            end
        end,
        units = groups.cursor,
        label = "CA Boat",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        --IsUsable = function(self) return (WarGodSpells["Wrath"]:CDRemaining() < 0.25 or WarGodSpells["Starfire"]:CDRemaining() < 0.25) and WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {20, 180}) and player.combat and WarGodUnit.active_enemies > 0 and buff_ca_inc:Down() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,

    })

    AddSpellFunction("Balance","Incarnation: Chosen of Elune",baseScore + 997,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            local lustRemains = LustRemaining()
            --variable.cd_condition&(astral_power>90&(buff.kindred_empowerment_energize.up|!covenant.kyrian)|covenant.night_fae|buff.bloodlust.up&buff.bloodlust.remains<20+(conduit.precise_alignment.time_value))&(variable.convoke_desync|cooldown.convoke_the_spirits.ready)|interpolated_fight_remains<20+(conduit.precise_alignment.time_value)
            if buffNotMine.kindred_empowerment.up
                    or (not equipped.empyreal_ordnance.equipped) or (buff.empyreal_surge.up or WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() > 60 and WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() < 150) then
                if variable.cd_condition and --[[((player:Lunar_Power() >= 90 or buffNotMine.kindred_empowerment.up) and (buff.kindred_empowerment:Up() or (not covenant.kyrian))]] covenant.night_fae and (WarGodSpells["Convoke the Spirits"]:CDRemaining() < player.gcd) or (not covenant.night_fae)  --[[|interpolated_fight_remains<(talent.incarnation_chosen_of_elune.enabled and 30 or 20)+(conduit.precise_alignment.time_value)]]
                then
                    local empOrdSlot = equipped.empyreal_ordnance.slotIndex
                    local bellSlot = empOrdSlot == 13 and 14 or 13
                    local _, trinket2ready = GetInventoryItemCooldown("player",bellSlot)
                    if trinket2ready == 0 then
                        return true
                    end
                end
            end
        end,
        units = groups.cursor,
        label = "Incarn Boat",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        --IsUsable = function(self) return (WarGodSpells["Wrath"]:CDRemaining() < 0.25 or WarGodSpells["Starfire"]:CDRemaining() < 0.25) and WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {20, 180}) and player.combat and WarGodUnit.active_enemies > 0 and buff_ca_inc:Down() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,

    })

    --actions.boat+=/convoke_the_spirits,if=(variable.convoke_desync&!cooldown.ca_inc.ready|buff.ca_inc.up)&(buff.balance_of_all_things_nature.stack=5|buff.balance_of_all_things_arcane.stack=5)|fight_remains<10
    AddSpellFunction("Balance","Convoke the Spirits",baseScore + 995,{
        -- using stacks because it avoids checking a function
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return
            buff_ca_inc:Up() or (variable.convoke_desync and WarGodSpells["Celestial Alignment"]:CDRemaining() > 20) and (buff.balance_of_all_things:Stacks() > 3)--|fight_remains<10
        end,
        units = groups.noone,
        label = "Convoke BoAT",
        helpharm = "harm",
        maxRange = 40,
        quick = true,
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return (WarGodControl:AllowCDs () and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, 120}) or buff_ca_inc:Up()) and player.combat and WarGodUnit.active_enemies > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })


    AddSpellFunction("Balance","Sunfire",baseScore + 990,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped or eclipse:In_Solar() or eclipse:In_Lunar() then return end
            return AP_Check(self.spell) and
                    variable.dot_requirements
        end,
        units = groups.targetable,
        label = "Sunfire Refresh Quick Boat",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Missing, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 12},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })
    --actions.boat+=/moonfire,target_if=refreshable&target.time_to_die>13.5,if=ap_check&variable.dot_requirements
    AddSpellFunction("Balance","Moonfire",baseScore + 980,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped or eclipse:In_Solar() or eclipse:In_Lunar() then return end
            return AP_Check(self.spell) and
                    variable.dot_requirements
        end,
        units = groups.targetable,
        label = "Moonfire Refresh Quick Boat",
        andDelegates = {Delegates.IsSpellInRange, Delegates.DoT_Missing, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        scorer = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 6.6, ttd = 12},
    })

    --actions.boat=ravenous_frenzy,if=buff.ca_inc.up
    --actions.boat+=/variable,name=critnotup,value=!buff.balance_of_all_things_nature.up&!buff.balance_of_all_things_arcane.up
    --actions.boat+=/adaptive_swarm,target_if=buff.balance_of_all_things_nature.stack<4&buff.balance_of_all_things_arcane.stack<4&(!dot.adaptive_swarm_damage.ticking&!action.adaptive_swarm_damage.in_flight&(!dot.adaptive_swarm_heal.ticking|dot.adaptive_swarm_heal.remains>3)|dot.adaptive_swarm_damage.stack<3&dot.adaptive_swarm_damage.remains<5&dot.adaptive_swarm_damage.ticking)

    --actions.boat+=/cancel_buff,name=starlord,if=(buff.balance_of_all_things_nature.remains>4.5|buff.balance_of_all_things_arcane.remains>4.5)&(cooldown.ca_inc.remains>7|(cooldown.empower_bond.remains>7&!buff.kindred_empowerment_energize.up&covenant.kyrian))
    --actions.boat+=/starsurge,if=!variable.critnotup&(covenant.night_fae|cooldown.ca_inc.remains>7|!variable.cd_condition&!covenant.kyrian|(cooldown.empower_bond.remains>7&!buff.kindred_empowerment_energize.up&covenant.kyrian))
    --actions.boat+=/starsurge,if=(cooldown.convoke_the_spirits.remains<5&(variable.convoke_desync|cooldown.ca_inc.remains<5))&astral_power>40&covenant.night_fae
    AddSpellFunction("Balance","Starsurge",baseScore + 800,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            local execute_time = 0.1
            if (not variable.critnotup) and (covenant.night_fae or (not WarGodControl:AllowCDs()) or (not Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, 120})) or WarGodSpells["Celestial Alignment"]:CDRemaining() > 7 or (not variable.cd_condition) and (not covenant.kyrian) or (WarGodSpells["Kindred Spirits"]:CDRemaining() > 7 and buff.kindred_empowerment:Down() and covenant.kyrian)) then
                --print('condition 1')
                return true
            elseif WarGodControl:AllowCDs() and Delegates:DamageCDWrapper(self.spell, WarGodUnit:GetTarget(), {4, 120}) then    -- this condition is mine
                if (WarGodSpells["Convoke the Spirits"]:CDRemaining() < 5 and (variable.convoke_desync or WarGodSpells["Celestial Alignment"]:CDRemaining() < 5) and (WarGodSpells[13]:CDRemaining() < 5 or WarGodSpells[14]:CDRemaining() < 5)) and covenant.night_fae then
                    --print('condition 2')
                    return true
                end
            end
        end,
        units = groups.targetable,
        label = "Starsurge",
        andDelegates = {Delegates.IsSpellInRange},
    })

    --actions.boat+=/variable,name=dot_requirements,value=(buff.ca_inc.remains>5&(buff.ravenous_frenzy.remains>5|!buff.ravenous_frenzy.up)|!buff.ca_inc.up|astral_power<30)&(!buff.kindred_empowerment_energize.up|astral_power<30)&(buff.eclipse_solar.remains>gcd.max|buff.eclipse_lunar.remains>gcd.max)

    --actions.boat+=/sunfire,target_if=refreshable&target.time_to_die>16,if=ap_check&variable.dot_requirements
    AddSpellFunction("Balance","Sunfire",baseScore + 760,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return --AP_Check(self.spell) and
                    buff.balance_of_all_things:Remains() < CastTimeFor("Wrath") and
                    (eclipse:In_Solar() or eclipse:In_Lunar()) and
                    variable.dot_requirements
        end,
        units = groups.targetable,
        label = "Sunfire Refresh Boat",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 5.4, ttd = 12},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })
    --actions.boat+=/moonfire,target_if=refreshable&target.time_to_die>13.5,if=ap_check&variable.dot_requirements
    AddSpellFunction("Balance","Moonfire",baseScore + 730,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return --AP_Check(self.spell) and
                    buff.balance_of_all_things:Remains() < CastTimeFor("Starfire") and
                    (eclipse:In_Solar() or eclipse:In_Lunar()) and
                    variable.dot_requirements
        end,
        units = groups.targetable,
        label = "Moonfire Refresh Boat",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotDotBlacklisted--[[, Delegates.SunfireTargetCondition, ]]},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {--[[aura = "sunfire", ]]threshold = 6.6, ttd = 12},
        Castable = function(self) return Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        needNotFace = true,
    })
    --actions.boat+=/stellar_flare,target_if=refreshable&target.time_to_die>16+remains,if=ap_check&variable.dot_requirements
    AddSpellFunction("Balance","Stellar Flare",baseScore + 700,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return --[[AP_Check(self.spell) and ]]buff.balance_of_all_things:Down() and
                    (eclipse:In_Solar() or eclipse:In_Lunar()) and
                    variable.dot_requirements
        end,
        units = groups.targetable,
        label = "Stellar Flare Refresh Boat",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.DoT_Pandemic, Delegates.DoT_TTD_Estimate, Delegates.NotCastingThisAtTargetAlready, Delegates.NotDotBlacklisted},
        ["scorer"] = ScoreByInvertedDebuffTimeRemaining,
        args = {threshold = 7.2, ttd = 16},
        Castable = function(self) return (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function(self) return talent.stellar_flare.enabled and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        helpharm = "harm",
        maxRange = 45,
    })
    --actions.boat+=/force_of_nature,if=ap_check
    --actions.boat+=/fury_of_elune,if=(eclipse.in_any|eclipse.solar_in_1|eclipse.lunar_in_1)&(!covenant.night_fae|(astral_power<95&(variable.critnotup|astral_power<30|variable.is_aoe)&(variable.convoke_desync&!cooldown.convoke_the_spirits.up|!variable.convoke_desync&!cooldown.ca_inc.up)))&(cooldown.ca_inc.remains>30|astral_power>90&cooldown.ca_inc.up&(cooldown.empower_bond.remains<action.starfire.execute_time|!covenant.kyrian)|interpolated_fight_remains<10)&(dot.adaptive_swarm_damage.remains>4|!covenant.necrolord)
    --actions.boat+=/kindred_spirits,if=(eclipse.lunar_next|eclipse.solar_next|eclipse.any_next|buff.balance_of_all_things_nature.remains>4.5|buff.balance_of_all_things_arcane.remains>4.5|astral_power>90&cooldown.ca_inc.ready)&(cooldown.ca_inc.remains>30|cooldown.ca_inc.ready)|interpolated_fight_remains<10



    --actions.boat+=/variable,name=aspPerSec,value=eclipse.in_lunar*8%action.starfire.execute_time+!eclipse.in_lunar*6%action.wrath.execute_time+0.2%spell_haste
    --actions.boat+=/starsurge,if=(interpolated_fight_remains<4|(buff.ravenous_frenzy.remains<gcd.max*ceil(astral_power%30)&buff.ravenous_frenzy.up))|(astral_power+variable.aspPerSec*buff.eclipse_solar.remains+dot.fury_of_elune.ticks_remain*2.5>120|astral_power+variable.aspPerSec*buff.eclipse_lunar.remains+dot.fury_of_elune.ticks_remain*2.5>120)&eclipse.in_any&(!buff.ca_inc.up|!talent.starlord.enabled)&((!cooldown.ca_inc.up|covenant.kyrian&!cooldown.empower_bond.up)|covenant.night_fae)&(!covenant.venthyr|!buff.ca_inc.up|astral_power>90)|(talent.starlord.enabled&buff.ca_inc.up&(buff.starlord.stack<3|astral_power>90))|buff.ca_inc.remains>8&!buff.ravenous_frenzy.up&!talent.starlord.enabled
    AddSpellFunction("Balance","Starsurge",baseScore + 500,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            if (--[[interpolated_fight_remains<4|]](buff.ravenous_frenzy:Remains()<player.gcd * ceil(player:Lunar_Power() / 30) and buff.ravenous_frenzy:Up())) or
            (player:Lunar_Power() + variable.aspPerSec * eclipse:SolarRemains()--[[ + dot.fury_of_elune.ticks_remain*2.5]] > 120 or
                    player:Lunar_Power() + variable.aspPerSec * eclipse:LunarRemains() --[[+dot.fury_of_elune.ticks_remain*2.5]] > 120) and eclipse:In_Any() and (buff_ca_inc:Down() or
                    (not talent.starlord.enabled)) and ((WarGodSpells["Celestial Alignment"]:CDRemaining() > player.gcd or covenant.kyrian and WarGodSpells["Kindred Spirits"]:CDRemaining() > player.gcd) or
                    covenant.night_fae) and ((not covenant.venthyr) or buff_ca_inc:Down() or player:Lunar_Power() > 90)
                    or (talent.starlord.enabled and buff_ca_inc:Up() and (buff.starlord:Stacks() < 3 and buff.starlord:Stacks() > 0 or player:Lunar_Power() > 90)) or buff_ca_inc:Remains() > 8 and buff.ravenous_frenzy:Down() and (not talent.starlord.enabled) then
                return true
            end
        end,
        units = groups.targetable,
        label = "Starsurge Boat",
        andDelegates = {Delegates.IsSpellInRange},
    })
    --actions.boat+=/new_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3)&ap_check
    --actions.boat+=/half_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3)&ap_check
    --actions.boat+=/full_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3)&ap_check
    --actions.boat+=/warrior_of_elune
    AddSpellFunction("Balance","Warrior of Elune",baseScore + 400,{
        func = function(self) return not runeforge.balance_of_all_things.equipped end,
        units = groups.noone,
        label = "WoE Boat",
        quick = true,
        IsUsable = function(self) return talent.warrior_of_elune and buff.warrior_of_elune:Stacks() < 1 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0)end
    })

    --actions.boat+=/starfire,if=eclipse.in_lunar|eclipse.solar_next|eclipse.any_next|buff.warrior_of_elune.up&buff.eclipse_lunar.up|(buff.ca_inc.remains<action.wrath.execute_time&buff.ca_inc.up)
    AddSpellFunction("Balance","Starfire",baseScore + 390,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            if eclipse:Any_Next() then
                return GetSpellCount("Starfire") == 2 and player.casting == "Starfire" or GetSpellCount("Starfire") == 1
            else
                return eclipse:In_Lunar() or eclipse:Solar_Next() and (player.casting ~= "Starfire" or GetSpellCount("Starfire") ~= 1) or eclipse:Any_Next() and (player.casting ~= "Starfire" or GetSpellCount("Starfire") ~= 1) or buff.warrior_of_elune.up and buff.eclipse_lunar.up or (buff_ca_inc:Remains() < CastTimeFor("Wrath") and buff_ca_inc:Up())
            end
        end,
        units = groups.targetable,
        label = "Starfire Boat",
        --[[Castable = function(self)
            local castTime = CastTimeFor(self.spell)
            return castTime == 0 or
                    talent.stellar_drift.enabled and castTime <= buff.starfall:Remains() and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) or
                    (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) and Delegates:MoveInWrapper(self.spell, player, {}) > CastTimeFor(self.spell) end,]]
        Interrupt = function(other) return other.spell == "Solar Beam" end,
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
    })
    --actions.boat+=/wrath
    AddSpellFunction("Balance","Wrath",baseScore + 360,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            local caRemains = buff_ca_inc:Remains()
            if caRemains > CastTimeFor("Wrath") then
                return true
            elseif caRemains <= 0 then
                return true
            end
        end,
        units = groups.targetable,
        label = "Wrath",
        --[[Castable = function(self)
            local castTime = CastTimeFor(self.spell)
            return castTime == 0 or
                    talent.stellar_drift.enabled and castTime <= buff.starfall:Remains() and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) or
                    (not IsMoving()) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) and Delegates:MoveInWrapper(self.spell, player, {}) > CastTimeFor(self.spell)
        end,]]
        Interrupt = function(other) return other.spell == "Solar Beam" end,
        andDelegates = {Delegates.UnitIsEnemy, Delegates.IsSpellInRange},
        helpharm = "harm",
        maxRange = 45,
        quick = true,
    })

    AddSpellFunction("Balance","Starfire",baseScore + 330,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return true
        end,
        units = groups.targetable,
        andDelegates = {Delegates.UnitIsEnemy},
        label = "Starfire Filler",
    })

    ----------------------------- Fallthru --------------------------------------

    --actions.fallthru=starsurge,if=!runeforge.balance_of_all_things.equipped
    AddSpellFunction("Balance","Starsurge",baseScore + 200,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return player:Lunar_Power() >= 90-- or (not WarGodControl:AOEMode())
        end,
        units = groups.targetable,
        label = "Starsurge Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })
    --actions.fallthru+=/sunfire,target_if=dot.moonfire.remains>remains
    AddSpellFunction("Balance","Sunfire",baseScore + 190,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return true
        end,
        units = groups.targetable,
        label = "Sunfire MF > SF",
        andDelegates = {Delegates.IsSpellInRange, Delegates.MoonfireRemainsGTSunfireRemains},
    })

    --actions.fallthru+=/moonfire
    AddSpellFunction("Balance","Moonfire",baseScore + 160,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return true
        end,
        units = groups.targetable,
        label = "Moonfire Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })

    AddSpellFunction("Balance","Sunfire",baseScore + 130,{
        func = function(self)
            if not runeforge.balance_of_all_things.equipped then return end
            return true
        end,
        units = groups.targetable,
        label = "Sunfire Filler",
        andDelegates = {Delegates.IsSpellInRange},
    })

end