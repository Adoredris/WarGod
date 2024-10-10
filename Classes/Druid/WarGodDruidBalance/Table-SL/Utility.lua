--
-- Created by IntelliJ IDEA.
-- User: Flora
-- Date: 30/06/2017
-- Time: 6:22 PM
-- To change this template use File | Settings | File Templates.
--
local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local azerite = player.azerite

local WarGodControl = WarGod.Control
local GetUnitSpeed = GetUnitSpeed

local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

local GetShapeshiftForm = GetShapeshiftForm


local upairs = upairs
local select = select

local IsActiveBattlefieldArena = IsActiveBattlefieldArena

---------TEMP-------------
local WGBM = WarGod.BossMods
local WarGodUnit = WarGod.Unit
--local Delegates = Rotations.Delegates
local WarGodCore = WarGod.Control
--------------------------



local GetNumGroupMembers = GetNumGroupMembers


setfenv(1, Rotations)
function GetNumLowGroupMembers()
    local num = 0
    for guid,unit in upairs(groups.targetable) do
        if Delegates:UnitUnderXPercentHealthPredicted("Wild Growth", unit, {percent = 0.5}) then
            num = num + 1
        end
    end
    return num
end

do

    AddSpellFunction("Balance", "Regrowth",23900,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Regrowth to Top",
        andDelegates = {Delegates.UnitMustBeTopped, Delegates.NotCastingThisAtTargetAlready, Delegates.HoT_Pandemic},
        args = {threshold = 3.6},
        helpharm = "help",
        maxRange = 45,
    })

    --[[AddSpellFunction("Balance", "Swiftmend",23500,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Swiftmend to Top",
        andDelegates = {Delegates.UnitMustBeTopped, Delegates.UnitHasHot},
        --args = {threshold = 4.5},
        helpharm = "help",
        maxRange = 45,
    })]]

    AddSpellFunction("Balance", "Rejuvenation",23000,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Rejuv to Top",
        andDelegates = {Delegates.UnitMustBeTopped, Delegates.HoT_Pandemic},
        args = {threshold = 4.5},
        helpharm = "help",
        maxRange = 45,
    })

    AddSpellFunction("Balance","Soothe",19980,{
        --func = function(self) return (not player.casting) and (not player.channel) end,
        units = groups.targetable,
        label = "Druid Purge",
        andDelegates = {Delegates.IsSpellInRange,Delegates.PurgeWrapper, Delegates.HasEnrageEffect},
        --["scorer"] = Delegates.ScoreGenericPurge,
        helpharm = "harm",
        maxRange = 45,
        isCC = true,
        IsUsable = function(self) return talent.soothe.enabled and player:Mana_Percent() > 0.2 and WarGodControl:AutoPurge() end,
    })

    AddSpellFunction("Balance", "Wild Growth",12900,{
        -- using stacks because it avoids checking a function
        func = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) and GetNumLowGroupMembers() >= 4 and buff.celestial_alignment:Stacks() < 1 and buff.incarnation_chosen_of_elune:Stacks() < 1 and (not UnitInRaid("player")) and player.health_percent < 0.7 end,
        units = groups.player,
        label = "WG Player",
        args = {percent = 0.5},
        helpharm = "help",
        maxRange = 45,
        Castable = function(self)
            return ((not IsMoving()) or CastTimeFor(self.spell) == 0)
        end,
        IsUsable = function(self) return talent.wild_growth.enabled and player:Mana_Percent() > 0.3 and GetNumGroupMembers() >= 4 and player.casting ~= self.spell and WarGodControl:HighSustain() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end
    })

    AddSpellFunction("Balance", "Regrowth",12015,{
        -- using stacks because it avoids checking a function
        func = function(self)
            return buff.celestial_alignment:Stacks() < 1 and buff.incarnation_chosen_of_elune:Stacks() < 1 and buff.frenzied_regeneration:Down() and Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.5}) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {}))-- and player:DebuffRemaining("Well-Honed Instincts", "HARMFUL") > 0
        end,
        units = groups.player,
        label = "Regrowth Player",
        --andDelegates = {Delegates.UnitUnderXPercentHealthPredicted},
        --args = {percent = 0.5},
        helpharm = "help",
        maxRange = 45,
        Castable = function(self) return ((not IsMoving()) or CastTimeFor(self.spell) == 0) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function() return player:Mana_Percent() > 0.5 and WarGodControl:HighSustain() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0)  end,
    })

    AddSpellFunction("Balance", "Regrowth",12013,{
        -- using stacks because it avoids checking a function
        func = function(self) return buff.celestial_alignment:Stacks() < 1 and buff.incarnation_chosen_of_elune:Stacks() < 1 and ((not UnitInRaid("player")) or IsActiveBattlefieldArena()) and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        units = groups.targetable,
        label = "Regrowth Others",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.UnitUnderXPercentHealthPredicted, Delegates.NotFriendlyBlacklistWrapper, Delegates.UnitIsNotPlayer},
        args = {percent = 0.5},
    })

    AddSpellFunction("Balance","Solar Beam",20000,{
        --func = function(self) return not player.casting end,       -- dodgy attempt to try to stagger interrupts
        units = groups.targetable,
        label = "Boom Kick",
        ["andDelegates"] = {Delegates.IsSpellInRange--[[, Delegates.HasSpellToInterrupt_LatestPossibleInterrupt]],Delegates.HasSpellToInterrupt,Delegates.InterruptWrapper},
        ["args"] = {},
        isCC = true,
        offgcd = true,
        helpharm = "harm",
        maxRange = 45,
        quick = true,
        --Interrupt = function(self) return true end,
        IsUsable = function(self) return talent.solar_beam.enabled and player:Mana_Percent() > 0.2 and WarGodControl:AutoKick() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })

    -- renewal
    AddSpellFunction("Balance", "Renewal",12080,{
        -- using stacks because it avoids checking a function
        func = function(self) return player.health_percent < 0.5 and buff.frenzied_regeneration.down and player.debuff.wellhoned_instincts:Up() > 0 and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})--[[ and Delegates:FriendlyPriorityWrapper(self.spell, player, {}) > 0]]) end,
        units = groups.noone,
        label = "Emergency CD Heal",
        helpharm = "help",
        IsUsable = function(self) return talent.renewal.enabled end
    })

    -- swiftmend
    --[[AddSpellFunction("Balance", "Swiftmend",12035,{
        -- using stacks because it avoids checking a function
        func = function(self) return player.health_percent < 0.7 and buff.frenzied_regeneration.down and player:DebuffRemaining("Well-Honed Instincts", "HARMFUL") > 0 and Delegates:UnitHasHot(self.spell, player, {}) and GetShapeshiftForm() == 0 and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {}))  end,
        units = groups.player,
        label = "Swiftmend Self Low",
        --["andDelegates"] = {Delegates.UnitUnderXPercentHealthPredicted, Delegates.UnitHasHot},
        args = {percent = 0.3},
        helpharm = "help",
        maxRange = 45,
    })

    AddSpellFunction("Balance", "Swiftmend",12030,{
        -- using stacks because it avoids checking a function
        func = function(self) return player.health_percent < 0.3 and buff.frenzied_regeneration.down and player:DebuffRemaining("Well-Honed Instincts", "HARMFUL") > 0 and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) and Delegates:UnitHasHot(self.spell, player, {}) end,
        units = groups.player,
        label = "Swiftmend Self Emergency",
        --["andDelegates"] = {Delegates.UnitUnderXPercentHealthPredicted},
        --args = {percent = 0.3},
        helpharm = "help",
        maxRange = 45,
        IsUsable = function() return player:Mana_Percent() > 0.35 and talent.swiftmend.enabled and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0 or buff.cat_form:Stacks() > 0) end,
    })]]

    AddSpellFunction("Balance", "Rejuvenation",12010,{
        func = function(self)
            if player.health_percent < 0.3 and buff.frenzied_regeneration.down and player:DebuffRemaining("Well-Honed Instincts", "HARMFUL") > 0 and (not Delegates:UnitHasHot(self.spell, player, {})) then
                if IsMoving() then
                    return true
                end
            end
        end,
        units = groups.player,
        label = "Rejuv Emergency Moving",
        andDelegates = {Delegates.HoT_Missing},
        args = {threshold = 4.5},
        helpharm = "help",
        maxRange = 45,
    })


    --[[AddSpellFunction("Balance","Innervate",18125, {
        func = function(self) return InCombatLockdown()
        end,
        units = groups.targetable,
        andDelegates = {Delegates.IsSpellInRange, Delegates.InnervateRaid,Delegates.NoInnervate},
        label = "Innervate",
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
    })]]

    AddSpellFunction("Balance","Innervate",18101, {
        func = function(self) return InCombatLockdown()--[[ and Delegates:HealCDWrapper(self.spell, player, {})]]
        end,
        units = groups.targetable,
        andDelegates = {Delegates.IsSpellInRange, Delegates.InnervateRaid, Delegates.NoInnervate, Delegates.HealCDWrapper},
        label = "Innervate",
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return talent.innervate.enabled  end
    })

    AddSpellFunction("Balance","Innervate",18100, {
        func = function(self) return InCombatLockdown()
        end,
        units = groups.targetable,
        andDelegates = {Delegates.IsSpellInRange, Delegates.InnervateParty, Delegates.NoInnervate},
        label = "Innervate",
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return talent.innervate.enabled end
    })

    --[[AddSpellFunction("Balance","Innervate",18124, {
        --func = function(self) return InCombatLockdown() and not UnitInRaid("player") and Delegates:HealCDWrapper() end,
        func = function(self) return InCombatLockdown() and not UnitInRaid("player") end,
        units = groups.targetable,
        ["andDelegates"] = {Delegates.InnervateParty, Delegates.NoInnervate},
        label = "Innervate",
    })]]

    --[[AddSpellFunction("Balance", "Regrowth",12013,{
        -- using stacks because it avoids checking a function
        func = function(self) return player.mana_percent > 0.25 and (not IsInInstance() or not UnitInRaid("player"))
                and player.health_percent > 0.5 and unit:AuraRemaining("Misery","player", nil, true) < CastTimeFor("Regrowth") end,
        units = groups.targetable,
        label = "Regrowth Others",
        ["andDelegates"] = {Delegates.UnitUnderXPercentHealth, Delegates.UnitIsNotPlayer},
        ["args"] = {percent = 0.5}
    })]]

    AddSpellFunction("Balance","Barkskin",16123, {
        func = function(self) return WGBM.Defensive(self.spell,player, {12, 60}) end,
        units = groups.noone,
        label = "Barkskin WGBM",
        helpharm = "help",
        offgcd = true
    })

    AddSpellFunction("Balance","Barkskin",16122, {
        func = function(self) return WGBM.Defensive == WGBM.default.Defensive and player.health_percent < 0.7 end,
        units = groups.noone,
        label = "Barkskin WGBM",
        helpharm = "help",
        offgcd = true
    })

    AddSpellFunction("Balance","Remove Corruption",19001,{
        func = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        units = groups.targetable,
        label = "Balance Target Cleanse",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.HasSpellToCleanse, Delegates.CleanseWrapper, Delegates.NotFriendlyBlacklistWrapper},
        ["scorer"] = Delegates.CleansePriorityWrapper,
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return player:Mana_Percent() > 0.1 and (WarGodControl:AutoCleanse() or (not player.combat))
                and (GetShapeshiftForm() == 0
                or buff.moonkin_form:Stacks() > 0 and (player.spec == "Balance" or player.spec == "Restoration")
                or buff.cat_form:Stacks() > 0 and player.spec == "Feral"
                or buff.bear_form:Stacks() > 0 and player.spec == "Guardian")
        end,

    })

    AddSpellFunction("Balance","Remove Corruption",19000,{
        func = function(self) return (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0) end,
        units = groups.targetable,
        label = "Balance Cleanse",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.HasSpellToCleanse, Delegates.CleanseWrapper, Delegates.NotFriendlyBlacklistWrapper},
        ["scorer"] = Delegates.CleansePriorityWrapper,
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return player:Mana_Percent() > 0.1 and (WarGodControl:AutoCleanse() or (not player.combat))
                and (GetShapeshiftForm() == 0
                or buff.moonkin_form:Stacks() > 0 and (player.spec == "Balance" or player.spec == "Restoration")
                or buff.cat_form:Stacks() > 0 and player.spec == "Feral"
                or buff.bear_form:Stacks() > 0 and player.spec == "Guardian")
        end,

    })

    AddSpellFunction("Balance","Nature's Vigil",18050.5,{
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
