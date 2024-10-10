local Rotations = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local charges = player.charges
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
local GetSpellInfo = C_Spell.GetSpellInfo

---------TEMP-------------
local WGBM = WarGod.BossMods
--local Delegates = Rotations.Delegates
local WarGodControl = WarGod.Control
local WarGodUnit = WarGod.Unit
local WarGodSpells = WarGod.Rotation.rotationFrames["Guardian"]
--------------------------


setfenv(1, Rotations)


local function TankingSomething()
    local threat = UnitThreatSituation("player")
    if threat then
        return threat >= 2
    end
end

local function NumThrashesRunning()
    return 1
end

local baseScore = 8000
do
    AddSpellFunction("Guardian","Barkskin",555, {
        func = function(self)
            if WGBM.default.Mitigation == WGBM.Mitigation and WGBM.Defensive(self.spell,player, {8+talent.improved_barkskin.rank * 4, 45-5.4*talent.survival_of_the_fittest.rank}) then
                return player:TimeInCombat() < 5 and (buff.rage_of_the_sleeper:Down() or (not talent.rage_of_the_sleeper.enabled))
            end
        end,
        units = groups.noone,
        label = "Barkskin (Def)",
        helpharm = "help",
        offgcd = true,
    })

    AddSpellFunction("Guardian","Barkskin",550, {
        func = function(self)
            if WGBM.default.Mitigation ~= WGBM.Mitigation and WGBM.Defensive(self.spell,player, {8+talent.improved_barkskin.rank * 4, 45-5.4*talent.survival_of_the_fittest.rank}) then
                return (buff.rage_of_the_sleeper:Down() or (not talent.rage_of_the_sleeper.enabled))
            end
        end,
        units = groups.noone,
        label = "Barkskin WGBM",
        helpharm = "help",
        offgcd = true,
    })


    AddSpellFunction("Guardian","Rage of the Sleeper",535, {
        func = function(self)
            if WGBM.default.Mitigation == WGBM.Mitigation and WGBM.Defensive(self.spell,player, {8, 60}) then
                if (WarGodSpells["Barkskin"]:CDRemaining() < 10) and buff.barkskin:Down() then
                    return true
                end
                return player:TimeInCombat() < 5 and buff.barkskin:Down() and WarGodSpells["Barkskin"]:CDRemaining() > 2
            end
        end,
        units = groups.noone,
        label = "Sleeper (Def)",
        helpharm = "help",
        offgcd = true,
        IsUsable = function(self) return talent.rage_of_the_sleeper.enabled end,
    })

    AddSpellFunction("Guardian","Rage of the Sleeper",530, {
        func = function(self)
            if WGBM.default.Mitigation ~= WGBM.Mitigation and WGBM.Defensive(self.spell,player, {8, 60}) then
                if (WarGodSpells["Barkskin"]:CDRemaining() < 10) and buff.barkskin:Down() and WarGodSpells["Barkskin"]:CDRemaining() > 2 then
                    return true
                end
            end
        end,
        units = groups.noone,
        label = "Sleeper",
        helpharm = "help",
        offgcd = true,
        IsUsable = function(self) return talent.rage_of_the_sleeper.enabled end,
    })



    AddSpellFunction("Guardian","Frenzied Regeneration",baseScore + 230,{
        func = function(self) return buff.frenzied_regeneration:Stacks() == 0 and (player.health_percent < 0.5 or player.health_percent < 0.3 and Delegates:UnitUnderXPercentHealthPredictedDamage(self.spell, player, {percent = 0.5})) and (not Delegates:FriendlyBlacklistWrapper(self.spell, player, {})) and player:TimeInCombat() > 3 end,
        units = groups.noone,
        label = "Regen High Threshold",
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 130,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and WGBM:Mitigation(self.spell, WarGodUnit.player, {}) end,
        units = groups.noone,
        label = "Ironfur Bossmods",
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 40 end,
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 125,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and WGBM.default.Mitigation == WGBM.Mitigation end,
        units = groups.noone,
        label = "Ironfur Bossmods",
        IsUsable = function(self) return buff.bear_form:Stacks() > 0 and player.rage >= 40 end,
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 120,{
        func = function(self) return TankingSomething() and buff.ironfur:Remains() < 1 and
                player.rage_deficit <= 9 + (talent.blood_frenzy.enabled and NumThrashesRunning() or 0)
        end,
        units = groups.noone,
        label = "Ironfur High Rage",
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 110,{
        func = function(self) return player.rage >= 40 and buff.ironfur:Remains() < 1 and TankingSomething() and
                buff.guardian_of_elune:Stacks() >= 1 and buff.guardian_of_elune:Remains() < 1 end,
        units = groups.noone,
        label = "Ironfur Longer Buff Expiring Soon",
    })

    AddSpellFunction("Guardian","Ironfur",baseScore + 100,{
        func = function(self) return player.rage_deficit <= 10 and TankingSomething() end,
        units = groups.noone,
        label = "Ironfur Longer Buff Expiring Soon",
        quick = true,
        offgcd = true,
    })




end
