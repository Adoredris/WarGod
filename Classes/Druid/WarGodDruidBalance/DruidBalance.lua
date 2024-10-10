if UnitClass("player") ~= "Druid" then C_AddOns.DisableAddOn("WarGodDruidBalance"); return end

local Druid = WarGod.Class
local Balance = LibStub("AceAddon-3.0"):NewAddon("WarGodDruidBalance", "AceConsole-3.0", "AceEvent-3.0")

local Rotation = WarGod.Rotation
local Class = WarGod.Class
local groups = WarGod.Unit.groups
local player = WarGod.Unit:GetPlayer()
local talent = player.trait
local buff = player.buff
local buffNotMine = player.buffNotMine
local azerite = player.azerite
local variable = player.variable
local covenant = player.covenant
local runeforge = player.runeforge
local eclipse = {}
player.eclipse = eclipse
local equipped = player.equipped

local pairs = pairs
local min = min
local max = max
local floor = floor
local strmatch = strmatch
local strlower = strlower
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local tinsert = tinsert
local tContains = tContains
local abs = abs
local WarGodUnit = WarGod.Unit
local harmOrPlates = WarGodUnit.groups.targetableOrPlates
local print = print

-------------Stuff needed for delegate only---------------
local GetSpecialization = GetSpecialization
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitPowerMax = UnitPowerMax
local UnitPower = UnitPower
local UnitCastingInfo = UnitCastingInfo
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitClass = UnitClass
local UnitIsUnit = UnitIsUnit
local UnitIsFriend = UnitIsFriend
local GetSpellCount = C_Spell.GetSpellCastCount
local GetSpellCastCount = C_Spell.GetSpellCastCount
local GetSpellCooldown = C_Spell.GetSpellCooldown
local SendChatMessage = SendChatMessage

local strlen = strlen
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local IsSpellInRange = IsSpellInRange
local strsplit = strsplit

local WarGod = WarGod
local WarGodControl = WarGod.Control
local WarGodSpells = WarGod.Rotation.rotationFrames["Balance"]


local floor = floor

--Delegates = Delegates

variable.sf_targets = 2



setfenv(1, Rotation)

local OriginalCastTimeFor = CastTimeFor
Rotation.CastTimeFor = function(spell)
    if strmatch(spell, "Moon$") then
        -- new moon
        if player.casting == "Full Moon" or player.casting ~= "New Moon" and GetSpellInfo("New Moon").name == "New Moon" then
            return 1 / (player.spell_haste / 100 + 1)
        end
        -- half moon
        if player.casting == "New Moon" or player.casting ~= "Half Moon" and GetSpellInfo("New Moon").name == "Half Moon" then
            return 2 / (player.spell_haste / 100 + 1)
        end
        -- full moon
        -- TODO handle double full moon talent
        if player.casting == "Half Moon" or player.casting ~= "Half Moon" and GetSpellInfo("New Moon").name == "Full Moon" then
            return 3 / (player.spell_haste / 100 + 1)
        end
    end
    return OriginalCastTimeFor(spell)
end

buff.balance_of_all_things.OriginalStacks = buff.balance_of_all_things.Stacks
buff.balance_of_all_things.OriginalRemains = buff.balance_of_all_things.Remains

local function BoATPredictedStacks(self)
    if (not runeforge.balance_of_all_things.equipped) then return 0 end
    local stacks = self:OriginalStacks()
    if buff.eclipse_solar.up or buff.eclipse_lunar.up then
        return stacks
    end
    if GetSpellCount("Wrath") == 1 and player.casting == "Wrath" then
        return 8
    elseif GetSpellCount("Starfire") == 1 and player.casting == "Starfire" then
        return 8
    end
    return 0
end
rawset(buff.balance_of_all_things, "Stacks", BoATPredictedStacks)

local function BoATPredictedUp(self)
    if (not runeforge.balance_of_all_things.equipped) then return end
    local stacks = self:OriginalStacks()
    if buff.eclipse_solar.up or buff.eclipse_lunar.up then
        return stacks > 0
    end
    if GetSpellCount("Wrath") == 1 and player.casting == "Wrath" then
        return true
    elseif GetSpellCount("Starfire") == 1 and player.casting == "Starfire" then
        return true
    end
end
rawset(buff.balance_of_all_things, "Up", BoATPredictedUp)

--[[local function BoATPredictedDown(self)
    return not BoATPredictedUp(self)
end
rawset(buff.balance_of_all_things, "Down", BoATPredictedDown)]]

local function BoATPredictedRemains(self)
    if (not runeforge.balance_of_all_things.equipped) then return 0 end
    local remains = self:OriginalRemains()
    if remains > 0 then
        return remains
    end
    if GetSpellCount("Wrath") == 1 and player.casting == "Wrath" then
        return 8
    elseif GetSpellCount("Starfire") == 1 and player.casting == "Starfire" then
        return 8
    end
    return 0
end
rawset(buff.balance_of_all_things, "Remains", BoATPredictedRemains)

function Delegates:MoonfireRemainsGTSunfireRemains(spell, unit, args)
    return unit.debuff.moonfire:Remains() > unit.debuff.sunfire:Remains()
end

-- having trouble perfecting this crap
function Delegates:DoT_Missing(spell, unit, args)
    --local aura = unit.aura[args and args.aura or spell]
    --return aura.remains < 1.5
    --return aura.remains < 1
    return unit.debuff[SimcraftifyString(args and args.aura or spell)]:Remains() < 1.5
end



local buff_ca_inc = {}
player.buff_ca_inc = buff_ca_inc
function buff_ca_inc:Up()
    return self:Remains() > 0
end

function buff_ca_inc:Down()
    return self:Remains() <= 0
end

function buff_ca_inc:Remains()
    if talent.incarnation_chosen_of_elune.enabled then
        return buff.incarnation_chosen_of_elune:Remains()
    end
    return buff.celestial_alignment:Remains()
end

function buff_ca_inc:Duration()
    if talent.incarnation_chosen_of_elune.enabled then
        return buff.incarnation_chosen_of_elune:Duration()
    end
    return buff.celestial_alignment:Duration()
end

local buff_kindred_empowerment_energize = {}
player.buff_kindred_empowerment_energize = buff_kindred_empowerment_energize
function buff_kindred_empowerment_energize:Up()
    return self:Remains() > 0
end

function buff_kindred_empowerment_energize:Down()
    return self:Remains() <= 0
end

function buff_kindred_empowerment_energize:Remains()
    local remains = buff.kindred_empowerment:Remains()
    if remains > 0 then
        return remains
    end
    return buff.lone_empowerment:Remains()
end

--[[buff.eclipse_solar.Empowerment = function(self)
    local remains = eclipse:SolarRemains()
    if remains == 15 then
        return 20
    elseif remains > 0 then
        for k,v in pairs (buff.eclipse_solar.points) do
            print(k .. ": " .. v)
        end
    end
    return 0
end


buff.eclipse_lunar.Empowerment = function()
    local remains = eclipse:LunarRemains()
    if remains == 15 then
    elseif remains > 0 then
        for i=1,40 do
            local buff, id,  _, _, _, _, _, _, _, _, _, _, _, _, _, _, num = UnitBuff("player", i)
            if buff == nil then return 0 end
            if id == 236151 then
                return num
            end
        end
    end
    return 0
end]]

buff.primordial_arcanic_pulsar.Value = function(self)
    if self.points == 0 then
        return 0
    end
    return self.points[1]
end

--eclipse.starfireCount = 0
--eclipse.wrathCount = 0
eclipse.next = GetSpellCount("Starfire") > 0 and GetSpellCount("Wrath") > 0 and "any" or GetSpellCount("Starfire") > 0 and "solar" or "lunar"
function eclipse:SolarRemains()
    local remains = buff.eclipse_solar:Remains()
    if remains > 0 then
        return remains
    end
    -- stuff goes in here to deal with currently casting starfire
    if GetSpellCount("Starfire") == 1 and player.casting == "Starfire" then
        return 15
    end
    return 0
end
eclipse.Solar_Remains = eclipse.SolarRemains

function eclipse:LunarRemains()
    local remains = buff.eclipse_lunar:Remains()
    if remains > 0 then
        return remains
    end
    -- stuff goes in here to deal with currently casting wrath
    if GetSpellCount("Wrath") == 1 and player.casting == "Wrath" then
        return 15
    end
    return 0
end
eclipse.Lunar_Remains = eclipse.LunarRemains

function eclipse:AnyRemains()
    return max(self:Lunar_Remains(), self:Solar_Remains())
end
eclipse.Any_Remains = eclipse.AnyRemains

--[[function eclipse:Solar_Next()
    local count = GetSpellCount("Starfire")
    if count > 1 then
        return true
    elseif count == 1 then
        -- this seems wrong
        --if player.casting ~= "Starfire" then
            return true
        --end
    elseif (eclipse:In_Lunar() and eclipse:LunarRemains() < CastTimeFor("Starfire")) then
        return true
    end
end

function eclipse:Lunar_Next()
    local count = GetSpellCount("Wrath")
    if count > 1 then
        return true
    elseif count == 1 then
        -- that seems wrong
        --if player.casting ~= "Wrath" then
            return true
        --end
    elseif (eclipse:In_Solar() and eclipse:SolarRemains() < CastTimeFor("Wrath")) then
        return true
    end
end]]

function eclipse:Any_Next()
    --[[if buff_ca_inc:Up() and buff_ca_inc:Remains() < CastTimeFor("Starfire") then
        return true
    elseif self:Lunar_Next() and self:Solar_Next() then
        return true
    end]]
end

function eclipse:In_Both()
    --return self:In_Lunar() and self:In_Solar()
    return buff_ca_inc:Remains() > 0
end

function eclipse:In_Any()
    return self:In_Lunar() or self:In_Solar()
end

function eclipse:In_Lunar()
    if buff_ca_inc:Remains() <= 0 and self:LunarRemains() > 0 then
        return true
    end
    if player.casting == "Wrath" and GetSpellCount("Wrath") == 1 then
        return true
    end
end

function eclipse:In_Solar()
    if self:SolarRemains() > 0 then
        return true
    end
    if player.casting == "Starfire" and GetSpellCount("Starfire") == 1 then
        return true
    end
end

do

    player.biggestGenAmount = 20


    player.lunar_gen = 0
    player.Lunar_Power = function(self)
        local power = self.lunarpower + self.lunar_gen
        if power >= 50 then
            if (talent.fury_of_elune.enabled and WarGodSpells["Fury of Elune"].CDRemaining and WarGodSpells["Fury of Elune"]:CDRemaining() > 52 or buff.eclipse_lunar:Up() and buff.eclipse_lunar:Remains() > buff.eclipse_lunar:Duration() - 8) then
                power = power + 5 * 2 -- * 2 is to provide some sort of buffer
            end
            if talent.natures_balance.enabled then
                power = power + 1 * 2 -- * 2 is to provide some sort of buffer
            end
        end
        return power
    end
    player.Lunar_Power_Deficit = function(self)
        --return self.lunarpower_deficit - self.lunar_gen
        return self.lunarpower_max - self:Lunar_Power()
    end
    player.Astral_Power = player.Lunar_Power
    player.Astral_Power_Deficit = player.Lunar_Power_Deficit

    local function GetAmountGeneratedBySpell(spell)
        local gen = 0
        if spell == "Starfire" then
            if talent.soul_of_the_forest.enabled and (eclipse:In_Lunar() or eclipse:In_Both()) then
                gen = gen + 13      -- hmm this one is weird cause it's based on stargets hit
            else
                gen = gen + 12
            end
        elseif spell == "Wrath" then
            if talent.soul_of_the_forest.enabled and (eclipse:In_Solar() or eclipse:In_Both()) then
                gen = gen + 13
            else
                gen = gen + 8
            end
        elseif spell == "Stellar Flare" then
            gen = gen + 8
            --elseif spell == "Starsurge" then
        elseif spell == "Moonfire" then
            gen = gen + 6
        elseif spell == "Sunfire" then
            gen = gen + 6
            --elseif spell == "Celestial Alignment" then
            --	extraGen = extraGen + 40

        elseif spell == "New Moon" or spell == "Half Moon" or spell == "Full Moon" then
            local curMoon = GetSpellInfo("New Moon").name
            if curMoon == "New Moon" then
                gen = gen + 10
            elseif curMoon == "Half Moon" then
                gen = gen + 20
            else
                gen = gen + 40
            end
        end
        return gen
    end

    function AP_Check(spell)
        if (spell == "Starsurge") then
            if player:Lunar_Power() >= (talent.rattle_the_stars.enabled and 36 or 40) then
                return true
            end
        else
            local extraGen = 3 + GetAmountGeneratedBySpell(spell) + GetAmountGeneratedBySpell(player.casting)

            if talent.fury_of_elune.enabled and WarGodSpells["Fury of Elune"]:CDRemaining() > 50 then
                extraGen = extraGen + 5 * 2
            elseif talent.natures_balance.enabled then
                extraGen = extraGen + 1 * 2
            end

            if talent.solstice.enabled then
                -- add some crap here
            end

            if buff.eclipse_lunar:Up() and buff.eclipse_lunar:Remains() > buff.eclipse_lunar:Duration() - 8 then
                extraGen = extraGen + 5 * 2
            end

            if talent.natures_balance.enabled then
                extraGen = extraGen + 2
            end
            if player:Lunar_Power_Deficit() - extraGen > 10 then
                return true
            end
        end
    end


end


--setmetatable(spell_targets, {__})
do
    --[[function Balance:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        --print(event)
        if unitid == "player" then
            local specId = GetSpecialization()
            if specId ~= 1 then
                Balance:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            else
                Balance:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            end
        end
    end
    Balance:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")]]

    local firstDamageTimes = {
        Moonfire = GetTime(),
        Sunfire = GetTime(),
        ["Wrath"] = GetTime(),
        ["Starfire"] = GetTime(),
        Starfall = GetTime()
    }
    local lastDamagedTargets = {
        Moonfire = {},
        Sunfire = {},
        ["Wrath"] = {},
        ["Starfire"] = {},
        Starfall = {},
    }
    local spell_targets_blacklist = {
        moonfire = {"Starfall"},
        sunfire = {"Starfall", "Moonfire"},
        solar_wrath = {"Starfall", "Moonfire"},
        lunar_strike = {"Starfall", "Moonfire"},
        starfall = {},
    }

    local spell_targets = {}
    setmetatable(spell_targets, {__index = function(t, lowerSpell)
        --if (lowerSpell == "moonfire") then
            local now = GetTime()
            local maxUnits = 0
            for spell,time in pairs(firstDamageTimes) do
                if (not tContains(spell_targets_blacklist[lowerSpell], spell)) then
                    if (now - time < 5) then
                        local units = 0
                        for k,v in pairs(lastDamagedTargets[spell]) do
                            units = units + 1
                        end
                        if (units > maxUnits) then
                            maxUnits = units
                        end
                    end
                end
            end
            return min(WarGodUnit.active_enemies, max(1, maxUnits))
        --end
        --return 1
    end})


    function Balance:COMBAT_LOG_EVENT_UNFILTERED(event)
        local timestamp, eventname, flagthatidunno, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destflags, destRaidFlags, spellId, spellName, spellschool, auraType = CombatLogGetCurrentEventInfo()
        if player.guid == sourceGUID then

            if eventname == "SPELL_DAMAGE" then
                if spellName == "Wrath" or spellName == "Starfire" or spellName == "Moonfire" or spellName == "Sunfire" or spellName == "Starsurge" then
                    player.lastSpellDamage = spellName
                end
            end

            if eventname == "SPELL_DAMAGE" and (spellName == "Wrath" or spellName == "Starfire" or spellName == "Starfall")
            or (eventname == "SPELL_AURA_APPLIED" or eventname == "SPELL_AURA_REFRESH") and (spellName == "Moonfire" or spellName == "Sunfire") then
                local now = GetTime()
                if (now - firstDamageTimes[spellName] > 0.2)then
                    for k,v in pairs(lastDamagedTargets[spellName]) do
                        lastDamagedTargets[spellName][k] = nil
                    end
                    firstDamageTimes[spellName] = now
                else

                end
                tinsert(lastDamagedTargets[spellName], destGUID)
            --[[elseif (eventname == "SPELL_AURA_APPLIED" or eventname == "SPELL_AURA_REFRESH") and (spellName == "Moonfire" or spellName == "Sunfire") then
                local now = GetTime()
                if (now - firstDamageTimes[spellName] > 0.2)then
                    for k,v in pairs(lastDamagedTargets[spellName]) do
                        lastDamagedTargets[spellName][k] = nil
                    end
                    firstDamageTimes[spellName] = now
                else

                end
                tinsert(lastDamagedTargets[spellName], destGUID)
                ]]
            end
        end
    end
    Balance:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    function Balance:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        --print(event)
        if unitid == "player" then
            local specId = GetSpecialization()
            if specId ~= 1 then
                Balance:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            else
                Balance:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            end
        end
    end
    Balance:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    WarGodUnit.spell_targets = spell_targets


end

--[[frame:SetScript("OnEvent", function(self, event, ...)
    Balance[event](self, event, ...); --









     one of the functions above
end)

for k, v in pairs(Balance) do
    frame:RegisterEvent(k);
end]]

function player:Setup()
    --print("moonkin setup")

    variable.cd_condition = buff.empyreal_surge.up or ((not equipped.empyreal_ordnance.equipped) or WarGodSpells[equipped.empyreal_ordnance.slotIndex] and WarGodSpells[equipped.empyreal_ordnance.slotIndex].CDRemaining and WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() < 170 and WarGodSpells[equipped.empyreal_ordnance.slotIndex]:CDRemaining() > 0) or covenant.kyrian or buffNotMine.kindred_empowerment.up

    variable.critnotup = buff.balance_of_all_things:Down()

    -- actions+=/variable,name=is_cleave,value=spell_targets.starfire>1
    variable.is_cleave = WarGodUnit.active_enemies > 1
    -- actions=variable,name=is_aoe,value=spell_targets.starfall>1&(!talent.starlord.enabled|talent.stellar_drift.enabled)|spell_targets.starfall>2
    variable.is_aoe = (WarGodControl:AOEMode() or WarGodControl:CleaveMode()) and WarGodUnit.active_enemies > 1

    variable.save_for_ca_inc = WarGodSpells["Celestial Alignment"] and WarGodSpells["Celestial Alignment"].CDRemaining and WarGodSpells["Celestial Alignment"]:CDRemaining() > 0
    variable.dream_will_fall_off = false

    variable.starfall_wont_fall_off = player:Lunar_Power() > 80 - (10 * buff.timeworn_dreambinder:Stacks())-(buff.starfall:Remains() * 3 / player.spell_haste)--[[-(dot.fury_of_elune.remains*5)]] and buff.starfall.up

    --actions+=/variable,name=convoke_desync,value=floor((interpolated_fight_remains-20-cooldown.convoke_the_spirits.remains)%120)>floor((interpolated_fight_remains-25-(10*talent.incarnation.enabled)-(conduit.precise_alignment.time_value)-cooldown.ca_inc.remains)%180)|cooldown.ca_inc.remains>interpolated_fight_remains|cooldown.convoke_the_spirits.remains>interpolated_fight_remains|!covenant.night_fae
    local caCDRemains = WarGodSpells["Celestial Alignment"] and WarGodSpells["Celestial Alignment"].CDRemaining and WarGodSpells["Celestial Alignment"]:CDRemaining() or 0
    local convokeCDRemains = WarGodSpells["Convoke the Spirits"] and WarGodSpells["Convoke the Spirits"].CDRemaining and WarGodSpells["Convoke the Spirits"]:CDRemaining() or 0
    variable.convoke_desync = abs(caCDRemains - convokeCDRemains) > 40 and WarGodUnit.active_enemies <= 3

    local modStarsurge = floor(buff.starsurge_empowerment:Stacks() / 4)
    --print(modStarsurge)
    --actions.aoe+=/variable,name=starfire_in_solar,value=spell_targets.starfire>4+floor(mastery_value%20)+floor(buff.starsurge_empowerment.stack%4)
    variable.starfire_in_solar = WarGodUnit.active_enemies > 4--[[ + floor(buff.eclipse_solar.Empowerment() / 4)]]
    -- need to work out what is going on with spell_targets

    --actions.boat+=/variable,name=dot_requirements,value=(buff.ca_inc.remains>5&(buff.ravenous_frenzy.remains>5|!buff.ravenous_frenzy.up)|!buff.ca_inc.up|astral_power<30)&(!buff.kindred_empowerment_energize.up|astral_power<30)&(buff.eclipse_solar.remains>gcd.max|buff.eclipse_lunar.remains>gcd.max)
    variable.dot_requirements = (buff_ca_inc:Remains() > 5 and (buff.ravenous_frenzy:Remains() > 5 or buff.ravenous_frenzy:Down()) or buff_ca_inc:Down() or player:Lunar_Power() < 30) and (buff.kindred_empowerment_energize:Down() or player:Lunar_Power() < 30) and (buff.eclipse_solar:Remains() > player.gcd or buff.eclipse_lunar:Remains() > player.gcd)
    --actions.boat+=/variable,name=aspPerSec,value=eclipse.in_lunar*8%action.starfire.execute_time+!eclipse.in_lunar*6%action.wrath.execute_time+0.2%spell_haste
    variable.aspPerSec=(eclipse:In_Lunar() and 1 or 0)*8 / CastTimeFor("Starfire") + (eclipse:In_Lunar() and 0 or 1) * 6 / CastTimeFor("Wrath") + 0.2 / player.spell_haste
end

player:Setup()

--WarGodRotations:RegisterForceCast("Regrowth", "player")
