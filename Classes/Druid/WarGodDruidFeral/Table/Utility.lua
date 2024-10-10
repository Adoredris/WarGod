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

local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown

local GetShapeshiftForm = GetShapeshiftForm

local upairs = upairs

---------TEMP-------------
local WGBM = WarGod.BossMods
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
    --[[AddSpellFunction(nil,"Soothe",19980,{
        func = function(self) return not player.casting and not player.channel end,
        units = groups.targetable,
        label = "Druid Purge",
        ["andDelegates"] = {Delegates.PurgeWrapper, Delegates.HasEnrageEffect},
        --["scorer"] = Delegates.ScoreGenericPurge,
        helpharm = "harm",
        maxRange = 45,
        isCC = true,
        IsUsable = function(self) return player:Mana_Percent() > 0.2 and WarGodControl:AutoPurge() end,
    })]]

    -- renewal
    AddSpellFunction("Feral", "Renewal",12080,{
        -- using stacks because it avoids checking a function
        func = function(self) return player.health_percent < 0.3 and buff.frenzied_regeneration.down end,
        units = groups.noone,
        label = "Emergency CD Heal",
        helpharm = "help",
    })

    AddSpellFunction("Feral","Survival Instincts",16122, {
        func = function(self) return WGBM.Defensive(self.spell,player, {6, 180}) end,
        units = groups.noone,
        label = "SI WGBM",
        helpharm = "help"
    })

    AddSpellFunction("Feral","Remove Corruption",19000,{
        func = function(self) return true end,
        units = groups.targetable,
        label = "Feral Cleanse",
        ["andDelegates"] = {Delegates.HasSpellToCleanse, Delegates.CleanseWrapper},
        --["scorer"] = Delegates.ScoreGenericDispel,
        helpharm = "help",
        maxRange = 45,
        IsUsable = function(self) return talent.remove_corruption.enabled and player:Mana_Percent() > 0.2 and WarGodControl:AutoCleanse() end,

    })

    AddSpellFunction("Feral","Skull Bash",20000,{
        --func = function(self) return not player.casting end,       -- dodgy attempt to try to stagger interrupts
        units = groups.targetable,
        label = "Feral Kick",
        ["andDelegates"] = {Delegates.IsSpellInRange, Delegates.HasSpellToInterrupt_LatestPossibleInterrupt,--[[Delegates.HasSpellToInterrupt, ]]Delegates.InterruptWrapper},
        ["args"] = {},
        isCC = true,
        offgcd = true,
        helpharm = "harm",
        maxRange = 16,
        quick = true,
        IsUsable = function(self) return (GetShapeshiftForm() == 1 or GetShapeshiftForm() == 2) and WarGodControl:AutoKick() end
    })

    AddSpellFunction("Feral","Barkskin",16123, {
        func = function(self) return WGBM.Defensive(self.spell,player, {12, 60}) end,
        units = groups.noone,
        label = "Barkskin WGBM",
        helpharm = "help",
        offgcd = true
    })

    AddSpellFunction("Feral","Barkskin",16122, {
        func = function(self) return WGBM.Defensive == WGBM.default.Defensive and player.health_percent < 0.7 end,
        units = groups.noone,
        label = "Barkskin WGBM",
        helpharm = "help",
        offgcd = true
    })

    AddSpellFunction("Feral", "Regrowth",12015,{
        -- using stacks because it avoids checking a function
        func = function(self)
            if (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) then
                return Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.5}) or Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.9}) and player.energy < 30
            end
        end,
        units = groups.player,
        label = "Regrowth Player",
        --andDelegates = {Delegates.UnitUnderXPercentHealthPredicted},
        --args = {percent = 0.5},
        helpharm = "help",
        maxRange = 45,
        Castable = function(self) return ((not IsMoving()) or CastTimeFor(self.spell) == 0) and Delegates:EnoughTimeToCastWrapper(self.spell, player, {}) end,
        IsUsable = function() return buff.predatory_swiftness.up or (player:Mana_Percent() > 0.5 and WarGodControl:HighSustain() and (buff.moonkin_form:Stacks() > 0 or GetShapeshiftForm() == 0))  end,
    })

    AddSpellFunction("Feral", "Regrowth",1.477,{
        -- using stacks because it avoids checking a function
        func = function(self)
            if (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) then
                if player.combopoints >= 4 and Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.8}) then
                    return true
                elseif player.combopoints >= 5 and Delegates:UnitUnderXPercentHealthPredicted(self.spell, player, {percent = 0.9}) then
                    return true
                end
            end
        end,
        units = groups.player,
        label = "Regrowth Player",
    })

    AddSpellFunction("Feral","Dash",3.6234,{
        func = function(self) return player:BuffRemaining("Time Spiral","HELPFUL") > 0
        end,
        units = groups.noone,
        label = "Dash",
        --IsUsable = function(self) return buff.dash:Down() end,
        --andDelegates = {Delegates.IsSpellInRange},
        --args = {aura = "Rip", threshold = 3},
        helpharm = "help",
        maxRange = 10,
    })
end
