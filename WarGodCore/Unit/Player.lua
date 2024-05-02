local Unit = WarGod.Unit
setfenv(1, Unit)

function GetPlayer()
    return unitsByGUID[UnitGUID("player")]
end
local player = GetPlayer()
player.dispellableauratypes = {}
player.channels = {}
player.variable = {}
player.prev_cast_times = {}
player.maxRange = 5

function Unit:UNIT_SPELL_HASTE()
    player.haste_percent = UnitSpellHaste("player")
    player.spell_haste = 1 / (1 + player.haste_percent / 100)

    player.gcd = max(player.spell_haste * 1.5, 0.75)

    --[[for spell,v in pairs(player.rotationSpells) do
        if v.tick_base_frequency then
            player.rotationSpells[spell].tick_time = v.tick_base_frequency * player.spell_haste
        end
    end]]

end
Unit:UNIT_SPELL_HASTE()
Unit:RegisterEvent("UNIT_SPELL_HASTE")

function Unit:MASTERY_UPDATE()
    -- not sure which function is  correct
    -- mastery, coefficient = GetMasteryEffect()
    -- mastery = GetMastery()
    player.mastery_value = GetMastery()
end
Unit:MASTERY_UPDATE()
Unit:RegisterEvent("MASTERY_UPDATE")

-- covenant
do
    local Covenant = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerCovenants", "AceConsole-3.0", "AceEvent-3.0")
    local covenant = {}


    function Covenant:COVENANT_CHOSEN(event, id)
        --print(id)
        if id == 1 then
            covenant.kyrian = true
            covenant.venthyr = nil
            covenant.night_fae = nil
            covenant.necrolord = nil
        elseif id == 2 then
            covenant.venthyr = true
            covenant.kyrian = nil
            covenant.night_fae = nil
            covenant.necrolord = nil
        elseif id == 3 then
            covenant.night_fae = true
            covenant.venthyr = nil
            covenant.kyrian = nil
            covenant.necrolord = nil
        elseif id == 4 then
            covenant.necrolord = true
            covenant.venthyr = nil
            covenant.kyrian = nil
            covenant.night_fae = nil
        end
    end
    Covenant:RegisterEvent("COVENANT_CHOSEN")
    Covenant:COVENANT_CHOSEN("ON_LOAD", C_Covenants.GetActiveCovenantID())

    player.covenant = covenant
end


-- charges
do
    local Charges = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerCharges", "AceConsole-3.0", "AceEvent-3.0")
    local charges = {}
    local function Update(self)
        local chargesCur, chargesMax, start, duration = GetSpellCharges(self.id)
        if (not chargesCur) then
            chargesCur = select(2,GetSpellCooldown(self.id)) < player.gcd and 1 or 0
            chargesMax = 1
        else
            if (chargesCur ~= chargesMax) then
                self.duration = duration
                self.next_charge_at = start + duration
            else
                self.next_charge_at = 0
            end
        end
        if (player.casting == self.name) then chargesCur = chargesCur - 1 end
        self.charges = max(0, chargesCur)   -- check... was  max(1, chargesCur)
        self.charges_max = chargesMax

        --if (playerObj.rotationSpells[self.name]) then
        --    playerObj.rotationSpells[self.name].usable = chargesCur and chargesCur > 0
        --            and (not playerObj.rotationSpells[self.name].Usability or playerObj.rotationSpells[self.name]:Usability())
        --    print(playerObj.rotationSpells[self.name].usable)
        --end
    end

    local function Fractional(self)
        --printTo(3,...)
        --printTo(3,'TBI - fractional charges')
        --printTo(3,self.charges + math.max((self.next_charge_at - GetTime()) / self.duration, 0))
        if (self.charges) then
            return self.charges + (self.next_charge_at > 0 and max((1 - (self.next_charge_at - GetTime()) / self.duration), 0) or 0)
        else
            return 1
        end
    end

    local function TimeTillMaxCharge(self)
        if (self.charges == self.charges_max) then
            return 0
        else
            --print((self.charges_max - 1 - self.charges) * self.duration + self.next_charge_at - GetTime())
            return (self.charges_max - 1 - self.charges) * self.duration + self.next_charge_at - GetTime()
        end
    end

    local unverified = {}


    setmetatable(charges, {
        __index = function(parent, simcName)
            local self = {}
            parent[simcName] = self
            self.Update = Update
            self.Fractional = Fractional
            self.TimeTillMaxCharge = TimeTillMaxCharge

            self.simcName = simcName

            self.name = simcName
            self.charges = 3
            self.charges_max = 3
            self.next_charge_at = 0
            self.duration = 1

            --self.name = verifiedName[simcAuraName]
            self.id = 1     -- that's useless


            local i = 1
            local name, subname, spellId = GetSpellBookItemName(1, BOOKTYPE_SPELL)
            while (name and SimcraftifyString(name) ~= simcName) do
                i = i + 1
                name, subname, spellId = GetSpellBookItemName(i, BOOKTYPE_SPELL)
            end
            if (name) then
                self.name = name
                self.id = spellId
                self:Update()
                return self
            else
                --[[for i=1,3 do
                    for j=1,7 do
                        local talentID, talentName, _, _, _, spellId, _, _,_, haveTalent, haveFakeTalent = GetTalentInfo(j, i,1)
                        if (SimcraftifyString(talentName) == simcName) then
                            self.name = talentName
                            self.id = spellId
                            self:Update()
                            return self
                        end
                    end

                end]]
                self.name = gsub(gsub(gsub(simcName, "^%a", strupper), "_%a", strupper), "_", " ")
                if (GetSpellInfo(self.name)) then
                    self.id = select(7, GetSpellInfo(self.name))
                    self:Update()
                else
                    unverified[simcName] = true
                end

            end
            --parent[simcName] = self
            return self
        end
    })



    function Charges:SPELL_UPDATE_CHARGES(event, ...)
        --local charges = playerObj.charges
        --print("boo")
        for spell,v in pairs(player.charges) do
            if (type(v) == "table" and spell ~= "__index") then
                v:Update()
            end
        end
    end

    function Charges:SpellEvents(event, unitid, lineId, spellId)
        --print(event)
        if unitid == "player" then
            --print(event)
            local spellname = GetSpellInfo(spellId)
            if (spellname) then
                local simcName = SimcraftifyString(spellname)
                if (unverified[simcName]) then
                    player.charges[simcName].name = spellname
                    player.charges[simcName].id = spellId
                end
                if rawget(player.charges, simcName) then
                    player.charges[simcName]:Update()
                end
            end
        end
    end


    function Charges:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            for k,v in pairs(player.charges) do
                player.charges[k] = nil
            end
        end
    end
    function Charges:UNIT_SPELLCAST_START(...)
        Charges:SpellEvents(...)
    end
    function Charges:UNIT_SPELLCAST_STOP(...) Charges:SpellEvents(...) end
    function Charges:UNIT_SPELLCAST_SUCCEEDED(...) Charges:SpellEvents(...) end
    Charges:RegisterEvent("SPELL_UPDATE_CHARGES")
    Charges:RegisterEvent("UNIT_SPELLCAST_START")
    Charges:RegisterEvent("UNIT_SPELLCAST_STOP")
    Charges:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    Charges:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    player.charges = charges
end

do
    local Traits = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerTraits", "AceConsole-3.0", "AceEvent-3.0")
    local trait = {}

    setmetatable(trait, {
        __index = function(parent, simcName)
            local self = {}
            parent[simcName] = self
            self.name = simcName
            self.enabled = false

            local configId = GetActiveConfigID()
            if configId then
                local configInfo = GetConfigInfo(configId)
                for _, treeId in ipairs(configInfo.treeIDs) do
                    local nodes = GetTreeNodes(treeId)
                    for _, nodeId in ipairs(nodes) do
                        local node = GetNodeInfo(configId, nodeId)
                        if node and node.ID ~= 0 then
                            for _, talentId in ipairs(node.entryIDs) do
                                local entryInfo = GetEntryInfo(configId, talentId)
                                local definitionInfo = GetDefinitionInfo(entryInfo.definitionID)

                                local talentName = GetSpellInfo(definitionInfo.spellID)
                                if (SimcraftifyString(talentName) == simcName) then
                                    self.name = talentName
                                    self.treeId = treeId
                                    self.nodeId = nodeId
                                    self.talentId = talentId
                                    if node.activeEntry
                                            and node.activeEntry.entryID == talentId then
                                        self.rank = node.currentRank

                                        if node.currentRank > 0 then
                                            self.enabled = true
                                        end
                                    end

                                end
                            end
                        end

                    end
                end


            end
            return self
        end
    })

    -- this is doing the wrong thing currently
    function Traits:TRAIT_CONFIG_UPDATED(...)

        --[[for k,v in pairs(talent) do
            if v == nil then print('talent was nil') end
            if v.row == nil then print('row was nil for ' .. k); return end
            local talentID, talentName, _, _, _, _, _, _,_, haveTalent, haveFakeTalent = GetTalentInfo(v.row, v.column,1)
            v.enabled = haveTalent or haveFakeTalent
        end]]

        local configId = GetActiveConfigID()
        if configId then
            for k,v in pairs(trait) do
                if (not v.nodeId) then print(v.name) else
                    local node = GetNodeInfo(configId, v.nodeId)
                    if node.activeEntry
                    --[[and node.activeEntry.entryID == talentId]] then
                        if v.talentId == node.activeEntry.entryID then
                            v.rank = node.currentRank

                            v.enabled = node.currentRank > 0
                        else
                            v.rank = 0

                            v.enabled = nil
                        end
                    end
                end
            end
        end
    end
    Traits:RegisterEvent("TRAIT_CONFIG_UPDATED")

    function Traits:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            for k,v in pairs(trait) do
                trait[k] = nil
            end
        end
    end
    Traits:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    player.trait = trait
    player.talent = trait
end

-- talent
if 1==0 then
    local Talents = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerTalents", "AceConsole-3.0", "AceEvent-3.0")
    local talent = {}

    setmetatable(talent, {
        __index = function(parent, simcName)
            local self = {}
            parent[simcName] = self
            self.name = simcName
            self.enabled = false

            for i=1,3 do
                for j=1,7 do
                    local talentID, talentName, _, _, _, _, _, _,_, haveTalent, haveFakeTalent = GetTalentInfo(j, i,1)
                    if (SimcraftifyString(talentName) == simcName) then
                        self.name = talentName
                        self.column = i
                        self.row = j
                        if (haveTalent or haveFakeTalent)then
                            self.enabled = true
                        end
                        break
                    end
                end


            end
            return self
        end

    })

    function Talents:PLAYER_TALENT_UPDATE(...)
        for k,v in pairs(talent) do
            if v == nil then print('talent was nil') end
            if v.row == nil then print('row was nil for ' .. k); return end
            local talentID, talentName, _, _, _, _, _, _,_, haveTalent, haveFakeTalent = GetTalentInfo(v.row, v.column,1)
            v.enabled = haveTalent or haveFakeTalent
        end
    end
    Talents:RegisterEvent("PLAYER_TALENT_UPDATE")
    function Talents:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            for k,v in pairs(talent) do
                talent[k] = nil
            end
        end
    end
    Talents:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    player.talent = talent
end

-- power
do
    local Power = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerPower", "AceConsole-3.0", "AceEvent-3.0")

    local powerMappings = {}
    local function LookupPowerType(powerType)
        --print(powerType)
        if (powerMappings[powerType]) then
            return powerMappings[powerType]
        end

        for k,v in pairs(EnumPowerType) do
            if powerType == strlower(k) then
                --print(powerType)
                --print(strlower(k))
                --print(v)
                powerMappings[powerType] = v
                return powerMappings[powerType]
            end
        end
        print("Didn't find " .. powerType)
    end

    function Power:UNIT_POWER_UPDATE(event,unitId, powerType)
        --print(event)
        if (unitId == "player") then
            powerType = gsub(strlower(powerType), "_", "")
            --print(powerType .. " = " .. LookupPowerType(powerType))
            local power = UnitPower(unitId, LookupPowerType(powerType))
            player[powerType] = power
            if player[powerType.."_max"] then
                player[powerType.."_deficit"] = player[powerType.."_max"] - power

            end
            --player[strlower(powerType)] = power
            --print(powerType)
            --[[if (powertype == "MANA") then
                SetPower(player.casting, SPELL_POWER_MANA)
            elseif (powertype == "ENERGY") then
                player.energy = UnitPower("player", SPELL_POWER_ENERGY)
                player.energy_deficit = player.energy_max - player.energy
            elseif (powertype == "CHI") then
                player.chi = UnitPower("player", SPELL_POWER_CHI)
                player.chi_deficit = player.chi_max - player.chi
            end]]

        end
    end
    Power:RegisterEvent("UNIT_POWER_UPDATE")
    --Power:RegisterEvent("UNIT_POWER_FREQUENT", Power.UNIT_POWER_UPDATE)

    if UnitClass("player") == "Death Knight" then
        function Power:RUNE_POWER_UPDATE(event, runeIndex, added)
            local readyRunes = 0
            local timeOfNextRune = GetTime() + 1337
            local nextRuneDuration = 0
            for i=1,6 do
                local start, duration, ready = GetRuneCooldown(i)
                if ready then
                    readyRunes = readyRunes + 1
                elseif start + duration < timeOfNextRune then
                    timeOfNextRune = start + duration
                    nextRuneDuration = duration
                end
            end
            if readyRunes < 6 then
                player.timeOfNextRune = timeOfNextRune
                player.nextRuneDuration = nextRuneDuration
            end
            player.runes = readyRunes-- + (readyRunes < 6 and 1 - (timeOfNextRune - GetTime()) / nextRuneDuration or 0)
            player.runes_deficit = 6 - readyRunes
        end
        Power:RegisterEvent("RUNE_POWER_UPDATE")

        function player:RunesFractional()
            return player.runes + (player.runes < 6 and 1 - (player.timeOfNextRune - GetTime()) / player.nextRuneDuration or 0)
        end
        player.timeOfNextRune = GetTime() + 1337
        player.nextRuneDuration = 0
    end

    function Power:UNIT_MAXPOWER(event, unitId, powerType)
        --print(unitId)
        if (unitId == "player" or event == "PLAYER_ENTERING_WORLD") then
            powerType = gsub(strlower(powerType), "_", "")
            local powerMax = UnitPowerMax(unitId, LookupPowerType(powerType))
            player[powerType .. "_max"] = powerMax
            Power:UNIT_POWER_UPDATE(event, unitId, powerType)
            --[[if not powertype then
                local powerTypeNum = UnitPowerType("player")
                powertype = (powerTypeNum == 0 and "MANA")
            end
            if (powertype == "MANA") then
                player.mana_max = UnitPowerMax("player", SPELL_POWER_MANA)
            elseif (powertype == "ENERGY") then
                player.energy_max = UnitPowerMax("player", SPELL_POWER_ENERGY)
            elseif (powertype == "CHI") then
                player.chi_max = UnitPowerMax("player", SPELL_POWER_CHI)
            end
            Monk_PowerChanged(event, unitid, powertype)]]
        end
    end
    Power:RegisterEvent("UNIT_MAXPOWER")
    do  -- init
        local powerTypeNum, powerType = UnitPowerType("player")
        Power:UNIT_MAXPOWER("UNIT_MAXPOWER", "player",powerType)
        for i=0,16 do
            if (powerTypeNum ~= i) then
                if UnitPowerMax("player", i) > 0 then
                    for k,v in pairs(EnumPowerType) do
                        if (v == i) then
                            Power:UNIT_MAXPOWER("UNIT_MAXPOWER", "player",k)
                        end
                    end
                end
            end
        end
    end
    Power:RegisterEvent("UNIT_DISPLAYPOWER", Power.UNIT_MAXPOWER)



    function Power:PLAYER_ENTERING_WORLD(event)
        if UnitPowerMax("player", 0) > 0 then
            Power:UNIT_MAXPOWER("UNIT_MAXPOWER", "player","Mana")
        end
    end
    Power:RegisterEvent("PLAYER_ENTERING_WORLD", Power.PLAYER_ENTERING_WORLD)

    --Monk_MaxPowerChanged("UNIT_MAXPOWER", "player","MANA")
    --Monk_MaxPowerChanged("UNIT_MAXPOWER", "player","ENERGY")
    --Monk_MaxPowerChanged("UNIT_MAXPOWER", "player","CHI")

end

-- azerite
do
    local Azerite = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerAzerite", "AceConsole-3.0", "AceEvent-3.0")
    local azerite = {}


    -- iterate all the items you have looking for a trait with that simcName
    function FindTraitName(simcName)
        --print(GetTime())
        for slotIndex=1,5,2 do
            local loc = ItemLocation:CreateFromEquipmentSlot(slotIndex)
            if (loc:IsValid() and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc)) then
                for ringNum,ringTable in pairs(C_AzeriteEmpoweredItem.GetAllTierInfo(loc)) do
                    for index,azeritePowerID in pairs(ringTable.azeritePowerIDs) do
                        local traitName = GetSpellInfo(C_AzeriteEmpoweredItem.GetPowerInfo(azeritePowerID).spellID)
                        --print(traitName .. ringNum)
                        if (SimcraftifyString(traitName) == simcName) then
                            return traitName
                        end
                    end

                end

            end
        end

        --[[ for bagID=0,4 do
            for slotIndex=1,GetContainerNumSlots(bagID) do
                local itemID = GetContainerItemID(bagID, slotIndex)
                if (itemID) then
                    local loc = ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
                    if (C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc)) then
                        for ringNum,ringTable in pairs(C_AzeriteEmpoweredItem.GetAllTierInfo(loc)) do
                            for index,azeritePowerID in pairs(ringTable.azeritePowerIDs) do
                                local traitName = GetSpellInfo(C_AzeriteEmpoweredItem.GetPowerInfo(azeritePowerID).spellID)
                                --print(traitName .. ringNum)
                                if (SimcraftifyString(traitName) == simcName) then
                                    --print('found ' .. traitName)
                                    return traitName
                                end
                            end
                        end
                    end

                end

            end
        end]]
        return simcName
    end

    local function SetRank(self)
        self.rank = 0
        for slotIndex=1,5,2 do
            local loc = ItemLocation:CreateFromEquipmentSlot(slotIndex)
            if (C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc)) then
                for ringNum,ringTable in pairs(C_AzeriteEmpoweredItem.GetAllTierInfo(loc)) do
                    for index,azeritePowerID in pairs(ringTable.azeritePowerIDs) do
                        if C_AzeriteEmpoweredItem.IsPowerSelected(loc,azeritePowerID) then
                            if self.name == GetSpellInfo(C_AzeriteEmpoweredItem.GetPowerInfo(azeritePowerID).spellID) then
                                self.rank = self.rank + 1
                            end

                        end
                    end

                end

            end
        end
        if self.rank > 0 then
            self.enabled = true
        else
            self.enabled = false
        end
    end

    setmetatable(azerite, {
        __index = function(parent, simcName)
            local self = {}

            self.name = FindTraitName(simcName)

            self.rank = 0
            self.SetRank = SetRank

            if (self.name ~= simcName) then
                print("Saving " .. self.name)
                self:SetRank()

                --rawset(parent, simcName, self)
                --else
                --    print(simcName)
            end
            rawset(parent, simcName, self)
            return self
        end
    })

    function Azerite:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED(event, t)
        if t.equipmentSlotIndex then
            for k,v in pairs(azerite) do
                v:SetRank()     -- could probably make less code run, but psh
            end
        end
    end
    Azerite:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")


    function Azerite:PLAYER_EQUIPMENT_CHANGED(event, slotIndex, someBool)
        if (slotIndex == 1 or slotIndex == 3 or slotIndex == 5) then
            for k,v in pairs(azerite) do
                v:SetRank()
            end
        end

    end
    Azerite:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    player.azerite = azerite
end

-- cast history
do
    local History = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerHistory", "AceConsole-3.0", "AceEvent-3.0")
    player.prev_gcd = ""
    local damageSpells = {}
    local prev_prev_gcd = "none"

    local lastLineIds = {}

    function History:UNIT_SPELLCAST_SENT(event, unitId, targetName, lineId, spellId)
        if (unitId == "player") then
            --print("UNIT_SPELLCAST_SENT: "..lineId)
            lastLineIds[lineId] = GetTime()
        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_SENT")

    function History:UNIT_SPELLCAST_START(event, unitId, lineId, spellId)
        if (unitId == "player") then
            local spellName = GetSpellInfo(spellId)
            if lastLineIds[lineId] then

                if spellName then
                    --if damageSpells[spellName] then
                    player.prev_gcd = spellName

                    --end
                    --player.casting = spellName
                end

            end
            if spellName then
                --if damageSpells[spellName] then

                --end
                player.casting = spellName
            end
            for k,time in pairs(lastLineIds) do
                if GetTime() - time > 1 then
                    lastLineIds[k] = nil
                    --print("removed old lineID")
                end
            end
        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_START")

    function History:UNIT_SPELLCAST_CHANNEL_START(event, unitId, lineId, spellId)
        if (unitId == "player") then
            --print("UNIT_SPELLCAST_CHANNEL_START: " .. lineId) -- this event never seems to happen
            local spellName = GetSpellInfo(spellId)
            if lastLineIds[lineId] then
                --print("a")

                if spellName then
                    --if damageSpells[spellName] then
                    player.prev_gcd = spellName

                    --end
                end

            end
            if spellName then
                player.channel = spellName
            end

        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

    function History:UNIT_SPELLCAST_STOP(event, unitId, lineId, spellId)
        if (unitId == "player") then
            player.casting = nil


        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_STOP")

    function History:UNIT_SPELLCAST_CHANNEL_STOP(event, unitId, lineId, spellId)
        if (unitId == "player") then
            player.channel = nil


        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

    function History:UNIT_SPELLCAST_FAILED(event, unitId, lineId, spellId)
        if (unitId == "player") then
            if lastLineIds[lineId] then
                local spellName = GetSpellInfo(spellId)
                if spellName--[[ and damageSpells[spellName] ]]then
                    player.prev_gcd = prev_prev_gcd
                    prev_prev_gcd = ""
                end

            end
        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_FAILED")

    function History:UNIT_SPELLCAST_SUCCEEDED(event, unitId, lineId, spellId)
        if (unitId == "player") then
            if lastLineIds[lineId] then
                local spellName = GetSpellInfo(spellId)
                --print(spellName)
                if spellName--[[ and damageSpells[spellName] ]]then
                    --print(spellName .. " succeeded")
                    player.prev_gcd = spellName
                    prev_prev_gcd = "none"

                end
                if UnitChannelInfo(unitId) == spellName then
                    --print('SUCCEEDED channelinfo')
                    player.channel = spellName
                end
            end
            for k,time in pairs(lastLineIds) do
                if GetTime() - time > 1 then
                    lastLineIds[k] = nil
                    --print("removed old lineID")
                end
            end
        end
    end
    History:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    function History:COMBAT_LOG_EVENT_UNFILTERED(event)
        local timestamp, eventname, flagthatidunno, sourceguid, sourcename, sourceflags, sourceRaidFlags, destguid, destname, destflags, destRaidFlags, spellid, spellname, spellschool, auraType = CombatLogGetCurrentEventInfo()

        if (sourceguid == player.guid and eventname == "SPELL_DAMAGE") then
            damageSpells[spellname] = true
        end
    end
    History:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


    function History:PLAYER_REGEN_ENABLED(event)
        player.combat = false
        player.combatCounter = GetTime()
    end
    History:RegisterEvent("PLAYER_REGEN_ENABLED")
    function History:PLAYER_REGEN_DISABLED(event)
        player.combat = true
        player.combatCounter = GetTime()
    end
    player.combat = InCombatLockdown()
    player.combatCounter = GetTime()
    History:RegisterEvent("PLAYER_REGEN_DISABLED")

    function History:ADDON_LOADED(event, addOnName)
        if InCombatLockdown() then
            player.combat = InCombatLockdown()
            player.combatCounter = GetTime()
            History:UnregisterEvent("ADDON_LOADED")
        end
    end
    History:RegisterEvent("ADDON_LOADED")

    function player:TimeInCombat()
        if player.combat then
            return GetTime() - player.combatCounter
        end
        return 0
    end

    function player:TimeOOC()
        if not player.combat then
            return GetTime() - player.combatCounter
        end
        return 0
    end
end

-- unit blacklist
do

    local errorLos = "Target not in line of sight"
    local errorBehind = "Target needs to be in front of you."
    local errorInvalid = "Invalid target"
    local errorObscured = "Your vision of the target is obscured"
    local errorRange = "Out of range."

    local Blacklist = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerBlacklist", "AceConsole-3.0", "AceEvent-3.0")
    local blacklist = {}
    local behind = {}
    local spells = {}
    function Blacklist:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
        if unitid == "player" then
            local spec = select(2, GetSpecializationInfo(GetSpecialization())) or "none"
            if spec ~= "none" then
                spells = Sky.Rotations and Sky.Rotations.rotationFrames[spec]-- or {}
                --print("spells")
            end
        end
    end
    Blacklist:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    function Blacklist:ADDON_LOADED(event,addon)
        if addon == "SkyRotations" then
            Blacklist:PLAYER_SPECIALIZATION_CHANGED("PLAYER_SPECIALIZATION_CHANGED","player")
        end
    end
    Blacklist:RegisterEvent("ADDON_LOADED")


    local lastSentLineId = 0
    local lastError = ""
    local playerSpells = {}

    local function ClearOldLines()
        local now = GetTime()
        for lineId,t in pairs(playerSpells) do
            if (now - t.time > 15) then
                --9printTo(3,'removed an old spell')
                playerSpells[lineId] = nil
            end
        end
    end

    function Unit:IsTempBlacklisted(guid)
        if (blacklist[guid]) then
            local now = GetTime()
            if (now - blacklist[guid] < 1) then
                --print("can't hit " .. guid)
                return true
            else
                blacklist[guid] = nil
            end
        end
        return false
    end

    function Unit:IsTempBehind(guid)
        if (behind[guid]) then
            local now = GetTime()
            if (now - behind[guid] < 1) then
                --print(UnitName(unitid) .. " is behind you")
                return true
            else
                behind[guid] = nil
            end
        end
        return false
    end

    -- called when you successfully cast something or when a set amount of time expires or when you couldn't find anything to do
    local function ClearTempBlacklist()
        --local removedSomething = false
        for k,v in pairs(blacklist) do
            blacklist[k] = nil
            --removedSomething = true
        end
        --[[if (removedSomething) then
            SkyCore:TriggerRefreshSpell()
        end]]
    end

    local function ClearBehind()
        for k,v in pairs(behind) do
            behind[k] = nil
        end
    end

    local function TempBlacklist(guid)
        --printTo(3,"Trying to blacklist")
        if (guid and blacklist[guid] == nil) then
            --printTo(3,"Blacklisted " .. guid)
            blacklist[guid] = GetTime()
            --SkyCore:ResetBestRotation()
        end
    end


    local function TempBlacklistBehind(guid)
        --[[print("TempBlacklistBehind")
        print(self)
        print(guid)]]
        if (guid and behind[guid] == nil) then
            --print("behind " .. guid)
            behind[guid] = GetTime()
            --SkyCore:ResetBestRotation()
        end

    end

    --local lastLineId

    function Blacklist:UNIT_SPELLCAST_SENT(event, unitId, targetName, lineId, spellId)
        if (unitId == "player") then
            local spellName = GetSpellInfo(spellId)
            --print(spellName)
            if spellName then
                if (rawget(spells, spellName)) then
                    --print("UNIT_SPELLCAST_SENT " .. lineId)
                    lastSentLineId = lineId
                    playerSpells[lineId] = {}
                    playerSpells[lineId].spell = spellName
                    playerSpells[lineId].targetName = targetName
                    playerSpells[lineId].time = GetTime()
                    --print(UnitName(queuedUnitId))
                    --print(targetName)
                    --[[if (targetName) then
                        print(...)
                    end]]

                    if (GetSpellInfo(player.queuedSpell) == spellName and UnitName(player.queuedUnitId) == targetName) then
                        --print("ooga booga")
                        --print(player.queuedGUID)
                        playerSpells[lineId].guid = player.queuedGUID--UnitGUID(unitId)
                        --print(playerSpells[lineId].guid)
                    end
                end

            end
        end
    end
    Blacklist:RegisterEvent("UNIT_SPELLCAST_SENT")

    function Blacklist:UI_ERROR_MESSAGE(event, ...)
        local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = ...
        if(arg2~=nil)then

            -- arg2 == "Target needs to be in front of you."
            -- arg2 == "Target not in line of sight"
            if (arg2 == errorBehind or arg2 == errorLos or arg2 == errorInvalid or arg2 == errorObscured) then
                --printTo(3,"UI_ERROR_MESSAGE")
                --printTo(3,...)
                --printTo(3,lastSentLineId)
                print(arg2)
                lastError = arg2

            elseif (arg2 == errorRange) then
                Sky.Rotations:RefreshRotation()
            end
        end
    end
    Blacklist:RegisterEvent("UI_ERROR_MESSAGE")

    local function PlayerSpells_Failed(event, unitId, lineId, spellId)
        --print('failed ' .. unitId)
        if (unitId == "player") then
            --print(event .. " " .. lineId)

            if (playerSpells[lineId]) then
                --print('boo')
                if (lastError == errorLos or lastError == errorInvalid or lastError == errorObscured) then
                    --if ()
                    TempBlacklist(playerSpells[lineId].guid)
                    for k,t in pairs(spells) do
                        t.timeSinceLastUpdate = 1337
                    end
                    ClearOldLines()
                    print(GetSpellInfo(spellId))
                    print(playerSpells[lineId].targetName)
                elseif (lastError == errorBehind) then
                    TempBlacklistBehind(playerSpells[lineId].guid)
                    for k,t in pairs(spells) do
                        t.timeSinceLastUpdate = 1337
                    end
                    ClearOldLines()
                end
                lastError = ""
            else
                local spellName = GetSpellInfo(spellId)
                --print("Attempted: " .. spellName)
                --print(player.queuedSpell)
                if spellName == GetSpellInfo(player.queuedSpell) and player.queuedUnitId then
                    if (lastError == errorLos or lastError == errorInvalid or lastError == errorObscured) then
                        --if ()
                        TempBlacklist(player.queuedGUID)
                        for k,t in pairs(spells) do
                            t.timeSinceLastUpdate = 1337
                        end
                        ClearOldLines()
                        print(spellName)
                        print(UnitName(player.queuedUnitId))
                    elseif (lastError == errorBehind) then
                        --print('blacklisting behind ' .. UnitName(player.queuedUnitId))
                        TempBlacklistBehind(player.queuedGUID)
                        for k,t in pairs(spells) do
                            t.timeSinceLastUpdate = 1337
                        end
                        ClearOldLines()
                    end
                    lastError = ""
                end
            end

        end
    end

    function Blacklist:UNIT_SPELLCAST_FAILED(...)
        PlayerSpells_Failed(...)
    end
    function Blacklist:UNIT_SPELLCAST_FAILED_QUIET(...)
        PlayerSpells_Failed(...)
    end
    Blacklist:RegisterEvent("UNIT_SPELLCAST_FAILED")
    Blacklist:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")

    function Blacklist:UNIT_SPELLCAST_START(event, unitId, lineId, spellId)
        --print(' ' .. unitId)
        if (unitId == "player") then
            local spellName = GetSpellInfo(spellId)
            if spellName then
                if (rawget(spells, spellName)) then
                    ClearTempBlacklist()
                    ClearBehind()

                    ClearOldLines()
                end
                -- generally used to try to prevent double casts on things like stellar flare, immolate, etc
                lastError = ""

            end
        elseif (unitId == "pet") then
            --printTo(3,)
        end

    end
    Blacklist:RegisterEvent("UNIT_SPELLCAST_START")

    function Blacklist:UNIT_SPELLCAST_SUCCEEDED(event, unitId, lineId, spellId)
        if (unitId == "player") then
            local spellName = GetSpellInfo(spellId)
            if spellName then
                if (rawget(spells, spellName)) then
                    ClearTempBlacklist()
                    ClearBehind()
                end
                if (playerSpells[lineId]) then
                    lastError = ""
                    ClearOldLines()
                end

            end
        end
    end
    Blacklist:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    function Blacklist:UNIT_SPELLCAST_CHANNEL_START(event, unitId, lineId, spellId)
        if (unitId == "player") then
            local spellName = GetSpellInfo(spellId)
            if spellName then
                if (rawget(spells, spellName)) then
                    ClearTempBlacklist()
                    ClearBehind()
                end

            end
        end
    end
end

do
    local Runeforge = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerRuneforge", "AceConsole-3.0", "AceEvent-3.0")
    local runeforge = {}

    local function SetEquipped(self, slotIndex)
        for k,v in pairs(runeforge) do
            v.equipped = nil
            for i=1,17 do
                local loc = ItemLocation:CreateFromEquipmentSlot(i)
                if loc:IsValid() and C_LegendaryCrafting.IsRuneforgeLegendary(loc) then
                    if SimcraftifyString(C_Item.GetItemName(loc)) == v.simcName then
                        v.equipped = true
                    end
                end

            end
        end
    end

    function FindRuneforgeName(simcName)
        local specRuneforgePowerIDs, otherSpecRuneforgePowerIDs  = C_LegendaryCrafting.GetRuneforgePowers()
        for k,powerID in pairs(specRuneforgePowerIDs) do
            local info = C_LegendaryCrafting.GetRuneforgePowerInfo(powerID)
            local name = info.name
            if SimcraftifyString(name) == simcName then
                return name
            end
        end
        return simcName
    end

    setmetatable(runeforge, {
        __index = function(parent, simcName)
            local self = {}

            self.name = FindRuneforgeName(simcName)
            self.simcName = simcName

            self.SetEquipped = SetEquipped

            if (self.name ~= simcName) then
                print("Saving " .. self.name)

            end
            rawset(parent, simcName, self)
            self:SetEquipped()
            return self
        end
    })


    function Runeforge:PLAYER_EQUIPMENT_CHANGED(event, slotIndex, someBool)
        --for k,v in pairs(runeforge) do
        SetEquipped(--[[slotIndex]])
        --end

    end
    Runeforge:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    player.runeforge = runeforge
end

do
    local Soulbind = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerSoulbind", "AceConsole-3.0", "AceEvent-3.0")
    local soulbind = {}

    function FindSoulbindName(simcName)
        return simcName
    end

    setmetatable(soulbind, {
        __index = function(parent, simcName)
            local self = {}

            self.name = FindSoulbindName(simcName)

            --self.rank = 0

            if (self.name ~= simcName) then
                print("Saving " .. self.name)
                --self:SetRank()

                --rawset(parent, simcName, self)
                --else
                --    print(simcName)
            end
            rawset(parent, simcName, self)
            return self
        end
    })



    --[[function Soulbind:RUNEFORGE_POWER_INFO_UPDATED(event, powerID)

    end
    Soulbind:RegisterEvent("RUNEFORGE_POWER_INFO_UPDATED")


    function Soulbind:NEW_RUNEFORGE_POWER_ADDED(event, powerID)

    end
    Soulbind:RegisterEvent("NEW_RUNEFORGE_POWER_ADDED")]]
    player.soulbind = soulbind
end

do
    local Conduit = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerConduit", "AceConsole-3.0", "AceEvent-3.0")
    local conduit = {}

    function FindConduitName(simcName)
        return simcName
    end

    setmetatable(conduit, {
        __index = function(parent, simcName)
            local self = {}

            self.name = FindConduitName(simcName)
            self.value = 0

            if (self.name ~= simcName) then
                print("Saving " .. self.name)
            end
            rawset(parent, simcName, self)
            return self
        end
    })

    --[[function Soulbind:RUNEFORGE_POWER_INFO_UPDATED(event, powerID)

    end
    Soulbind:RegisterEvent("RUNEFORGE_POWER_INFO_UPDATED")]]

    player.conduit = conduit
end

do
    local Equipped = LibStub("AceAddon-3.0"):NewAddon("SkyUnitPlayerEquipped", "AceConsole-3.0", "AceEvent-3.0")
    local equipped = {}

    local function SetEquipped()
        for k,v in pairs(equipped) do
            v.equipped = nil
            v.slotIndex = nil
            for i=1,17 do
                local loc = ItemLocation:CreateFromEquipmentSlot(i)
                if loc:IsValid() then
                    if SimcraftifyString(C_Item.GetItemName(loc)) == v.simcName then
                        v.equipped = true
                        v.slotIndex = i
                    end
                end
            end
        end
    end

    function FindItemNameId(simcName)
        for slotIndex=1,17 do
            local loc = ItemLocation:CreateFromEquipmentSlot(slotIndex)
            if (loc:IsValid()) then
                local itemName, itemId = C_Item.GetItemName(loc), C_Item.GetItemID(loc)
                if (SimcraftifyString(itemName) == simcName) then
                    return itemName, itemId
                end

            end
        end

        --[[for bagID=0,4 do
            for slotIndex=1,GetContainerNumSlots(bagID) do
                local itemID = GetContainerItemID(bagID, slotIndex)
                if (itemID) then
                    local loc = ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
                    local itemName, itemId = C_Item.GetItemName(loc), C_Item.GetItemID(loc)
                    if (SimcraftifyString(itemName) == simcName) then
                        return itemName, itemId
                    end

                end

            end
        end]]
        return simcName
    end

    local function ItemCDRemaining(slotno)
        --/run printTo(3,GetInventoryItemCooldown("player",10))
        --[[local start, duration, cdexists
        if slotno <= 18 then
            start, duration, cdexists = GetInventoryItemCooldown("player",slotno)
        else
            if GetItemCount(slotno) > 0 then
                start, duration, cdexists = GetItemCooldown(slotno)
            end
        end
        if(cdexists ~= 1)then
            --printTo(3,"BUG - SLOT : " .. slotno .. " CANNOT HAVE A CD")
            return GetTime() + 9999;
        end
        if(start==nil)then
            start=0;
            duration=0;
        end
        return start + duration - GetTime()]]
        print(self)
    end

    setmetatable(equipped, {
        __index = function(parent, simcName)
            local self = {}

            self.name, self.id = FindItemNameId(simcName)        -- fix this
            self.simcName = simcName

            self.SetEquipped = SetEquipped
            self.CDRemaining = ItemCDRemaining


            if (self.name ~= simcName) then
                print("Saving " .. self.name)
            end
            rawset(parent, simcName, self)
            self:SetEquipped()
            return self
        end,
    })

    function Equipped:PLAYER_EQUIPMENT_CHANGED(event, slotIndex, someBool)
        --for k,v in pairs(runeforge) do
        SetEquipped(--[[slotIndex]])
        --end

    end
    Equipped:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

    player.equipped = equipped
end

function player:HaventRecentlyDismounted()
    if (GetTime() - player.lastMountedTime > 5) then
        return true
    end
end
