--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 18/02/2017
-- Time: 4:52 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local player = WarGod.Unit:GetPlayer()
local strmatch = strmatch

local UnitBuff = C_UnitAuras.GetBuffDataByIndex
local UnitDebuff = C_UnitAuras.GetDebuffDataByIndex
local UnitAura = C_UnitAuras.GetAuraDataByIndex

do
    WarGod.BossMods.default.Priority = function(spell, unit, args)
        --if spell ~= "" then print('default priority') end
        local unitid = unit.unitid
        --print(unitid)
        --[[if (unit.name == "Explosives") then
            return 1000000, "default"
        else]]if unit.health_percent < 0.95 and unit:BuffRemaining("Inspiring Presence", "HELPFUL") > 0 then
            return 5000, "default"
        end

        local score = 10
        if UnitIsUnit(unitid, "target") then
            score = score + 5

        end
        if UnitIsUnit(unitid, "mouseover") then
            score = score + 3
        end
        return score, "default"

        --[[local index = 1
        if unitid and unitid ~= "" then
            index = GetRaidTargetIndex(unitid)
            if not index then
                if UnitIsUnit(unitid, "target") then
                    index = 1
                else
                    index = 0
                end
            else
                if index < 7 and index > 1 then
                    if UnitIsUnit(unitid, "target") then
                        index = 1
                    else
                        index = 0
                    end
                end
            end

        end

        return index + 2, "default"]]
    end
    WarGod.BossMods.Priority = WarGod.BossMods.default.Priority

    WarGod.BossMods.default.FriendlyPriority = function(spell, unit, args)
        return 10 - unit.health_percent
    end
    WarGod.BossMods.FriendlyPriority = WarGod.BossMods.default.FriendlyPriority

    -------------------------------------------------------------------

    -- the defensive dispel function
    WarGod.BossMods.default.Cleanse = function(spell, unit, args)
        --print('default cleanse code')
        if UnitGroupRolesAssigned("player") == "HEALER" then
            if unit:BuffRemaining("Cascading Terror", "HARMFUL") > 0 then
                return
            end
        end
        local dungeon, size = GetInstanceInfo()
        --[[if size == "party" then
            if unit:BuffRemaining("Cursed Spirit", "HARMFUL") > 0 then
                return true
            elseif unit:BuffRemaining("Diseased Spirit", "HARMFUL") > 0 then
                return true
            elseif unit:BuffRemaining("Poisoned Spirit", "HARMFUL") > 0 then
                return true
            end
        end]]
        if unit.name == "Afflicted Soul" then return true end
        local unitid = unit.unitid
        for i=1,40 do
            local t = UnitDebuff(unitid, i)
            if not t then return end
            if (t.dispelName == "Magic" or t.dispelName == "Disease" or t.dispelName == "Poison" or t.dispelName == "Curse")then
                if not t.duration or t.expirationTime == 0 then
                    return true
                else
                    if t.expirationTime - GetTime() > 3 then
                        return true
                    end
                end
            end
        end
        --return true
    end
    WarGod.BossMods.Cleanse = WarGod.BossMods.default.Cleanse

    WarGod.BossMods.default.CleansePriority = function(spell, unit, args)
        local unitid = unit.unitid
        if UnitIsUnit("player", unitid) then
            return 1
        end
        return WGBM.FriendlyPriority(spell, unit,args)
    end
    WarGod.BossMods.CleansePriority = WarGod.BossMods.default.CleansePriority

    -- the offensive dispel function
    WarGod.BossMods.default.Purge = function(spell, unit, args)
        local unitid = unit.unitid
        if unit:BuffRemaining("Lifebloom", "HELPFUL") > 0 then
            return
        end
        for i=1,40 do
            local t = UnitBuff(unitid, i)
            if not t then
                break
            end
            --if t.dispelName == "" then print("t.dispelName is empty which should mean Enrage...default.Purge") end
            if (t.dispelName == "Magic" or t.dispelName == "Enrage" or t.dispelName == "")then -- Enrages are "" for some reason?
                if not t.duration or t.expirationTime == 0 then
                    if GetNumGroupMembers() <= 2 or strmatch(UnitClassification(unitid), "elite") or UnitIsPlayer(unitid) then
                        return true
                    else
                    end
                else
                    --print(t.duration)
                    local remains = t.expirationTime - GetTime()
                    if remains < 0 then
                        print(spell .. " remains: " .. remains .. ", duration: " .. t.duration)
                    end
                    if remains > 3 then
                        --print('WarGod.BossMods.default.Purge')
                        if UnitClassification(unitid) == "elite" or UnitIsPlayer(unitid) then
                            return true
                            --else
                            --    print(UnitBuff(unitid, i))
                        end
                    end
                end
            end
        end
    end
    WarGod.BossMods.Purge = WarGod.BossMods.default.Purge

    -- the offensive dispel function
    WarGod.BossMods.default.Interrupt = function(spell, unit, args)
        local unitid = unit.unitid
        if unit.name == "Void-Touched Emissary" then
            return
        end
        return true
        --printTo(3,'default interrupt')
    end
    WarGod.BossMods.Interrupt = WarGod.BossMods.default.Interrupt

    WarGod.BossMods.default.AllowedToInterrupt = function(spell, unit, args)
        local unitid = unit.unitid
        return true
        --printTo(3,'default interrupt')
    end
    WarGod.BossMods.AllowedToInterrupt = WarGod.BossMods.default.AllowedToInterrupt

    WarGod.BossMods.default.Taunt = function(spell, unit, args)
        local unitid = unit.unitid

    end
    WarGod.BossMods.Taunt = WarGod.BossMods.default.Taunt

    -------------------------------------------------------------------

    WarGod.BossMods.default.DamageCD = function(spell, unit, args)
        --print('default ' .. spell)
        --local unitid = unit.unitid
        return InCombatLockdown()
        --return true
    end
    WarGod.BossMods.DamageCD = WarGod.BossMods.default.DamageCD



    -- this handles innervate too
    WarGod.BossMods.default.HealCD = function(spell, unit, args)
        local unitid = unit.unitid
        --[[if UnitGroupRolesAssigned("player") ~= "HEALER" then
            if WarGod.Unit:GetPlayer():BuffRemaining("Prideful","HARMFUL") > 0 then
                return
            end
            return true

        end]]
        if spell == "Innervate" then
            if spell == "Innervate" then
                --[[if GetSpecialization() ~= 2 or GetShapeshiftForm() ~= 2 or WarGod.Unit:GetPlayer().energy < 50 and WarGod.Unit:GetPlayer():TimeInCombat() > 40 then
                    return true
                end]]

            end
        end
        --return true
    end
    WarGod.BossMods.HealCD = WarGod.BossMods.default.HealCD

    -------------------------------------------------------------------

    -- hold instants, hold cooldowns type stuff (although holding cooldowns probably part of cooldown thingy)
    -- mechanic that quite likely will force you to move soon
    WarGod.BossMods.default.MoveIn = function(spell, unit, args)
        local unitid = unit.unitid
        --printTo(3,'default move_in')
        return 1337
    end
    WarGod.BossMods.MoveIn = WarGod.BossMods.default.MoveIn

    -- a particular mechanic is forcing that unit to move soon
    WarGod.BossMods.default.UnitMoveIn = function(spell, unit, args)
        local unitid = unit.unitid
        --printTo(3,...)
        if (GetUnitpeed(unitid) > 0) then
            return 0
        end
        return 1337
    end
    WarGod.BossMods.UnitMoveIn = WarGod.BossMods.default.UnitMoveIn

    -------------------------------------------------------------------



    -- stuff you should never nuke, there won't be anything in the blacklist by default for this
    WarGod.BossMods.default.DPSBlacklist = function(...--[[spell, unit, args]])
        --print('regular dpsblacklist')
        local spell, unit, args = ...
        local unitid = unit.unitid

        if unit:BuffRemaining("Spell Reflection","HELPFUL") > 0 or unit:BuffRemaining("Mass Spell Reflection","HELPFUL") > 0 then
            return true
        elseif unit:BuffRemaining("Divine Shield","HELPFUL") > 0 or unit:BuffRemaining("Ice Block","HELPFUL") > 0 then
            return true


            --[[elseif UnitCastingInfo(unitid) == "Teleport: The Eternal Palace" then --unit:BuffRemaining("Infested", "HELPFUL") > 0 then
                --if not UnitIsUnit("target", unitid) then
                return true
                --end
            elseif unit.name == "Enchanted Emissary" then
                if not UnitIsUnit("target", unitid) then
                    return true
                end]]
        end
        if WarGod.Control:SafeMode() then
            if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
                return
            end
            return true
        end
        if IsInInstance() then
            if GetNumGroupMembers() <= 5 then
                if unit.name == "Incorporeal Being" then return true end
            end
            --[[if WarGod.Unit:GetPlayer():BuffRemaining("Ny'alotha Incursion","HARMFUL") > 0 then
                if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
                    return
                end
                local name = unit.name
                if name == "Samh'rek, Beckoner of Chaos" or name == "Ravenous Fleshfiend" or
                        name == "Blood of the Corruptor" or name == "Mindrend Tentacle" or
                        name == "Urg'roth, Breaker of Heroes" or name == "Malicious Growth" or
                        name == "Voidweaver Mal'thir" or name == "Dummy 2" then
                    return
                end
                return true
            else
                if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") then
                    return
                end
                local name = unit.name
                if name == "Samh'rek, Beckoner of Chaos" or name == "Ravenous Fleshfiend" or
                        name == "Blood of the Corruptor" or name == "Mindrend Tentacle" or
                        name == "Urg'roth, Breaker of Heroes" or name == "Malicious Growth" or
                        name == "Voidweaver Mal'thir" or name == "Dummy 2" then
                    return true
                end
                return
            end]]
        else
            if UnitIsUnit(unitid, "mouseover") or UnitIsUnit(unitid, "target") or UnitAffectingCombat(unitid) then
                return
            end
            return true
        end
        return false
    end
    WarGod.BossMods.DPSBlacklist = WarGod.BossMods.default.DPSBlacklist

    -- generally needed for things totems and other things that never actually target anyone
    WarGod.BossMods.default.DPSWhitelist = function(spell, unit, args)
        --print('checking default whitelist')
        local unitid = unit.unitid
        local name = unit.name
        if (name == "Explosives") then
            return true
        elseif (UnitIsPlayer(unitid)) then
            return true
        --[[elseif name == "Raider's Training Dummy" then
            print("dummy is unit")
            return true]]
        elseif name == "Unbreakable Defender" then
            return true
        end
        return false
    end
    WarGod.BossMods.DPSWhitelist = WarGod.BossMods.default.DPSWhitelist

    WarGod.BossMods.default.AoeBlacklisted = function(spell, unit, args)
        if strmatch(unit.name, "Totem$") then
            return true
        elseif unit.name == "Explosives" then
            return true
        end
    end
    WarGod.BossMods.AoeBlacklisted = WarGod.BossMods.default.AoeBlacklisted

    WarGod.BossMods.default.DotBlacklisted = function(spell, unit, args)
        --[[if strmatch(unit.name, "Totem$") then
            return true
        end]]
    end
    WarGod.BossMods.DotBlacklisted = WarGod.BossMods.default.DotBlacklisted

    -- generally defensives that everyone is concerned with
    WarGod.BossMods.default.Defensive = function(spell, unit, args)
        if spell == "Nature's Vigil" then
            if GetSpecialization() == 2 and WarGod.Unit:GetPlayer().buff.incarnation_avatar_of_ashamane:Up() then
                return true
            elseif GetSpecialization() == 1 and WarGod.Unit:GetPlayer().buff_ca_inc:Up() then
                return true
            end
        elseif spell == "Vampiric Embrace" then
            if WarGod.Unit:GetPlayer().talent.vampiric_embrace.enabled then
                if WarGod.Unit:GetPlayer().buff.power_infusion:Up() then
                    if WarGod.Unit:GetPlayer().health_percent < 0.8 then
                        return true
                    elseif WarGod.Unit:GetPlayer().buff.power_infusion:Remains() < 13 then
                        return true
                    end
                end
            end
        else
            local hpPercent = player.health_percent
            if player.combat then
                --print('defensive default')
                if 1==1 then return true end
                if hpPercent < 0.9 then
                    return  args[2] <= 45
                elseif hpPercent < 0.75 then
                    return args[2] <= 60
                elseif hpPercent < 0.25 then
                    return args[2] <= 180
                end
            end
        end
        --return 1337
    end
    WarGod.BossMods.Defensive = WarGod.BossMods.default.Defensive

    WarGod.BossMods.default.DefensiveMagic = function(spell, unit, args)
        return
    end
    WarGod.BossMods.DefensiveMagic = WarGod.BossMods.default.DefensiveMagic

    -- don't think any of the args matter, unless I compare to how much in advance I should use it
    WarGod.BossMods.default.Mitigation = function(spell, unit, args)
        local unitid = unit.unitid
        --print('default Mitigation')

        -- normally shouldn't be here, but anyway
        local bossCasting = UnitCastingInfo("boss1")
        if UnitIsUnit("boss1target", "player") then
            if bossCasting == "Shatter" or bossCasting == "Void Lash" then
                return true
            end
        end
        local name = unit.name
        if name == "Urg'roth, Breaker of Heroes" then
            
        end
        if GetZoneText() == "Lunarfall" then
            return nil, true, true

        end
        return false
    end
    WarGod.BossMods.Mitigation = WarGod.BossMods.default.Mitigation

    WarGod.BossMods.default.FriendlyBlacklist = function(spell, unit, args)
        local unitid = unit.unitid
        if UnitIsPlayer(unitid) and UnitPhaseReason(unitid) ~= nil then
            local name = unit.name
            print(name .. " not in phase")
            return true
        elseif unit:BuffRemaining("Forgeborne Reveries", "HELPFUL") > 0 then
            return true
        end
    end
    WarGod.BossMods.FriendlyBlacklist = WarGod.BossMods.default.FriendlyBlacklist

    WarGod.BossMods.default.BurstIn = function(spell, unit, args)
        local unitid = unit.unitid
        --print('burst in 0')
        return 0
    end
    WarGod.BossMods.BurstIn = WarGod.BossMods.default.BurstIn


    do
        local maxEnemies = 1
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_REGEN_DISABLED")
        f:SetScript("OnEvent", function(self, event, ...)
            maxEnemies = 1
        end)


        WarGod.BossMods.default.AoeIn = function(spell, unit, args)
            local aoeIn = UnitExists("boss1") and 1337 or select(2, GetInstanceInfo()) == "party" and 20 or 1337
            if (WarGod.Unit.active_enemies >= maxEnemies) then
                maxEnemies = WarGod.Unit.active_enemies
                aoeIn = 0
            else

                local now = GetTime()
                for msg,time in pairs(WGBM.timers) do
                    local timeDiff = time - now
                    if timeDiff < aoeIn and timeDiff > -5 then
                        if strmatch(msg, "Adds") then
                            aoeIn = timeDiff
                        end
                    end
                end
            end
            if UnitExists("boss1") then
                return 1337
            end
            return aoeIn
        end
        WarGod.BossMods.AoeIn = WarGod.BossMods.default.AoeIn
    end

    -- multiply time to die by this amount
    WarGod.BossMods.default.TTDFactor = function(spell, unit, args)
        local unitid = unit.unitid
        --[[[local Unit = LegendaryStrings.groups.harmOrPlates
        local count = 0
        for k,v in pairs(Unit) do
            count = count + 1
        end

        return 1 * (1 + count) / 2]]
        return 1
    end
    WarGod.BossMods.TTDFactor = WarGod.BossMods.default.TTDFactor

    WarGod.BossMods.default.EnoughTimeToCast = function(spell, unit, args)
        local castTime = WarGod.Rotation.CastTimeFor(spell)
        local remains = WarGod.Unit:GetPlayer().debuffAnyone.quake:Remains()
        --if spell == "Convoke the Spirits" then print('hello') end
        --print(spell)
        if remains > 0 then
            if castTime == 0 then
                if player.channels then
                    local channels = player.channels
                    if channels[spell] then
                        if channels[spell] - 0.25 > remains then
                            return
                        end
                    end
                end
            else
                --print((castTime + 0.5) .. " > " .. remains)
                if castTime + 0.5 > remains then
                    return
                end

            end
        end
        return true
    end
    WarGod.BossMods.EnoughTimeToCast = WarGod.BossMods.default.EnoughTimeToCast

    WarGod.BossMods.default.Preheal = function(spell, unit, args)
        local unitid = unit.unitid
        return false
    end
    WarGod.BossMods.Preheal = WarGod.BossMods.default.Preheal

    WarGod.BossMods.default.ExtraHealthMissing = function(spell, unit, args)
        local total = 0
        local unitid = unit.unitid
        local inInstance, instanceType = IsInInstance()
        if inInstance and instanceType == "party" then
            if select(4,GetInstanceInfo()) == "Mythic Keystone" then
                for i=1,40 do
                    local debuffName = UnitDebuff(unitid,i)
                    if not debuffName then
                        break
                    end
                    if debuffName == "Grievous Wound" then
                        local percent = select(16, UnitDebuff(unitid, i))
                        total = total + (percent or 20) * 0.01 * unit.health_max * 4
                    end
                end
            end

        end
        return total
    end
    WarGod.BossMods.ExtraHealthMissing = WarGod.BossMods.default.ExtraHealthMissing

    WarGod.BossMods.default.BurstUnit = function(spell, unit, args)
        local unitid = unit.unitid
        local name = unit.name
        --[[if name == "Explosives" then
            return true
        end]]

        return false
    end
    WarGod.BossMods.BurstUnit = WarGod.BossMods.default.BurstUnit

    WarGod.BossMods.default.StunUnit = function(spell, unit, args)
        local unitid = unit.unitid
        local name = unit.name
        --[[if name == "Explosives" then
            return true
        end]]

        return false
    end
    WarGod.BossMods.StunUnit = WarGod.BossMods.default.StunUnit

    WarGod.BossMods.default.DotQuick = function(spell, unit, args)
        local dungeonName, dungeonType = GetInstanceInfo()
        if dungeonType == "raid" then
            if unit.health_percent > 0.8 then
                return true
            end
        elseif dungeonType == "arena" then
            return true
        end
        local unitid = unit.unitid
        if UnitIsUnit(unitid, "mouseover") and (not UnitIsUnit(unitid, "target")) and unit.name ~= "Explosives" then
            return true
        end
    end
    WarGod.BossMods.DotQuick = WarGod.BossMods.default.DotQuick
end

do

    WGBM:ResetToDefaults()
    function WGBM:PLAYER_ENTERING_WORLD()
        WGBM:ResetToDefaults()
    end
    WGBM:RegisterEvent("PLAYER_ENTERING_WORLD")
end

print("Loaded WGBM Defaults")