local WarGod = WarGod
local Rotation = WarGod.Rotation
setfenv(1, Rotation)

local curScore = 0

function RefreshSpell(self)
    local forceUpdatePixel = true
    --local debug = self.spell == "Sunfire"
    self.timeSinceLastUpdate = 0
    --print('hi')
    -- what is this section I commented out 3/8/21
    if (curScore >= self.maxScore) then
        --if debug then print('z') end
        self.curScore = 0
        return
    end
    --if self.spell == "Moonfire" then print(self.spell .. " " .. tostring(GetTime())) end
    local tentativeScore = 0
    --if debug then print('abc') end
    if (self.spell == "Nothing" or --[[ReadyToCastNewSpell() and self:Ready() and]] self:IsUsable() and self:Castable()) then
        if debug then print('a') end
        for score,condition in pairs(self.conditions) do
            if debug then print('b') end
            if score >= tentativeScore and condition.func(self)then

                local units = condition.units
                if debug then print(units.name) end
                if (units.name == "noone" ) then
                    tentativeScore = score
                    self.bestUnitId = "nounit"
                elseif (units.name == "cursor") then
                    tentativeScore = score
                    self.bestUnitId = "cursor"
                elseif (units.name == "player") then
                    if (condition.andDelegates == nil or type(condition.andDelegates) == "function" and condition:andDelegates(condition, self.spell, player, condition.args) or type(condition.andDelegates) == "table" and AllTrue(self.spell, player, condition.args, condition.andDelegates)) then
                        tentativeScore = score
                        self.bestUnitId = "player"
                    end
                else
                    local bestUnitIdSoFar = ""
                    local bestScoreSoFar = 0
                    local bestUnit
                    for guid,unit in upairs(units) do
                        --print(self.harm); print(unit.harm)
                        local unitId = unit.unitid
                        --print(unitId)
                        if unitId and (not UnitIsDeadOrGhost(unitId) and UnitHealth(unitId) > 0 or self.rez) and (IsValidFriend(self,unit, condition.args) or IsValidEnemy(self,unit, condition.args))then
                            if debug then print('valid unit') end
                            if (not WarGodUnit:IsTempBlacklisted(guid)) and (self.needNotFace or (not WarGodUnit:IsTempBehind(guid)) or unitId == "player") then
                                if debug then print('passed temp blacklist') end
                                local maxRange, minRange = UnitRange(unit)
                                if (maxRange <= self.maxRange and minRange >= self.minRange)then
                                    if debug then print('inRange') end
                                    if (condition.andDelegates == nil or type(condition.andDelegates) == "function" and condition:andDelegates(condition, self.spell, unit, condition.args) or type(condition.andDelegates) == "table" and AllTrue(self.spell, unit, condition.args, condition.andDelegates)) then
                                        if debug then print('andDelegates True') end
                                        if (condition.scorer == nil and self.scorer == nil) then
                                            if debug then print('no scorer for ' .. self.spell) end
                                            --if self.spell == "Wrath" then print('no scorer') end
                                            for index,unitid in pairs(unit.unitIds) do
                                                if UnitGUID(unitid) ~= guid then
                                                    print(unitid .. " doesn't match guid")
                                                elseif (not UnitIdTooHigh(unitid)) then
                                                    bestUnit = unit
                                                    bestUnitIdSoFar = unitid
                                                    bestScoreSoFar = score
                                                    break
                                                end
                                            end
                                            if bestScoreSoFar == score then
                                                break       -- unit loop
                                            end
                                        else
                                            --local debug = self.spell == "Crusader Strike"
                                            if debug then print('scorer for ' .. self.spell) end
                                            --if spellname == "Starsurge" then
                                            --    printTo(3,"using scorer for starsurge")
                                            --end
                                            local scorerScore = condition.scorer and condition:scorer(self.spell, unit, condition.args) or self:scorer(self.spell, unit, condition.args)

                                            if (type(scorerScore) ~= "number") then
                                                print("wtf happened")
                                            elseif (scorerScore > bestScoreSoFar) then
                                                if debug then print('best score changed for ' .. self.spell) end
                                                --bestScoreSoFar = scorerScore
                                                --self.bestUnit = unit.unitIds[1]
                                                ---------------------------------
                                                for index,unitid in pairs(unit.unitIds) do
                                                    if (not UnitIdTooHigh(unitid)) then
                                                        bestUnitIdSoFar = unitid
                                                        bestUnit = unit
                                                        bestScoreSoFar = scorerScore
                                                        if debug then print('found keybind for ' .. self.spell) end
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if (bestScoreSoFar > 0 and condition.BestTargetFunc(self.spell, bestUnit, condition.args)) then
                        tentativeScore = score

                        self.bestUnit = bestUnit
                        printTo(3, self.spell .. "@" .. bestUnit.name)
                        if self.bestUnitId ~= bestUnitIdSoFar then


                            self.bestUnitId = bestUnitIdSoFar
                            forceUpdatePixel = true
                        end
                    end
                end
            end
        end
    else
        --self.curScore = 0
    end

    if self.curScore ~= tentativeScore then
        self.curScore = tentativeScore
        forceUpdatePixel = true
    end
    if (forceUpdatePixel) then
        if notDebuggingRefresh then --[[print('refresh rotation a')]]RefreshRotation() end
    end
end

do
    local lastWhisper = ""
    local lastWhisperTime = 0

    local updateFrame, timeSinceLastUpdate, updateDelay = CreateFrame("Frame", "SetBestSpellFrame"), 0, 0.05
    local function RefreshRotation()
        --print("started refresh")
        timeSinceLastUpdate = 0
        local bestActionSoFar, bestUnitIdSoFar, bestScoreSoFar, bestUnitSoFar = "Nothing", "nounit", 0, {}
        --local bestLabelSoFar = ""
        if(1==0)then
        elseif(GetCurrentKeyBoardFocus() ~=nil)then --printTo(3,"Chatting")
            --print("chatting")
            --LegPixel:SetBothBySpellUnit ("null","null");
        elseif(WarGod.command and WarGod.commandSource) then
            --print('doing command stuff')
            if WarGod.command == "FollowMe" then
                local found = false
                for i=1,GetNumGroupMembers() - 1 do
                    local name = UnitName("party" .. i)
                    if name and strmatch(WarGod.commandSource, name) then
                        --print("found the guy to follow")
                        bestActionSoFar = "follow"
                        bestUnitIdSoFar = "party" .. i
                        found = true
                        break
                    end
                end
                if not found then
                    WarGod.command = nil
                    WarGod.commandSource = ""
                end
            elseif WarGod.command == "StopFollow" then
                bestActionSoFar = "follow"
                bestUnitIdSoFar = "player"
            end
        elseif(WarGod.Control:Off())then
            --print("off")
            --LegPixel:SetBothBySpellUnit ("null","null");
        elseif UnitIsDeadOrGhost("player") then

        elseif(IsNonCombatMounted())then
            --print("mounted")
            --print("not dpsing cause mounted")
            --LegPixel:SetBothBySpellUnit ("null","null");
        elseif(UnitInVehicle("player") and (UnitHasVehicleUI("player") or UnitIsPlayer("vehicle")) or HasOverrideActionBar())then
            local zoneText = GetZoneText()
            local vehicleName = UnitName("vehicle")
            if vehicleName == "Darkwing Assassin" then
                bestUnitIdSoFar = ""
                if WarGodUnit.vehicle.health_percent < 0.3 and ActionCooldownRemains(135) < 0.5 then
                    --print('doing button3')
                    bestActionSoFar = "OverrideActionBarButton3"
                elseif UnitExists("target") then
                    local skip = false
                    if CheckInteractDistance("target",3) then
                        if ActionCooldownRemains(134) < 0.5 then
                            for guid,unit in upairs(WarGodUnit.groups.targetableOrPlates) do
                                if unit:DebuffRemaining("Weakened","HARMFUL") > 0 then
                                    --print('doing button2')
                                    bestActionSoFar = "OverrideActionBarButton2"
                                    skip = true
                                    break
                                end
                            end
                        end
                        if (not skip) and ActionCooldownRemains(133) < 0.5 then
                            --print('doing button1')
                            bestActionSoFar = "OverrideActionBarButton1"
                        end
                    end

                end
            elseif vehicleName == "Darkwing Aggressor" then
                bestUnitIdSoFar = ""
                if WarGodUnit.vehicle.health_percent < 0.3 and ActionCooldownRemains(135) < 0.5 then
                    --print('doing button3')
                    bestActionSoFar = "OverrideActionBarButton3"
                elseif UnitExists("target") then
                    local skip = false
                    if CheckInteractDistance("target",3) then
                        if ActionCooldownRemains(134) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton2"
                        elseif ActionCooldownRemains(133) < 0.5 then
                            --print('doing button1')
                            bestActionSoFar = "OverrideActionBarButton1"
                        end
                    end

                end
            elseif vehicleName == "Prototype Aquilon" then
                if GetTime() < lastWhisperTime + 0.5 then
                    if (lastWhisper == "Start pressing buttons!" or lastWhisper == "Buttons! Quickly, the buttons!") and ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    elseif (lastWhisper == "Use the lever, Maw Walker!" or lastWhisper == "Pull on one of the levers!") and ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"
                    elseif (lastWhisper == "There are no operating instructions! Try hitting it!" or lastWhisper == "A sharp strike to the head always works!") and ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"
                    end
                end
            elseif vehicleName == "Wild Flayedwing" then    -- WQ in maldraxxus
                if GetTime() < lastWhisperTime + 0.5 then
                    if lastWhisper == "The flayedwing is scared, soothe it with gentle pats!" and ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    elseif lastWhisper == "The flayedwing is trying to shake you off, hold on tight!" and ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"
                    elseif lastWhisper == "The flayedwing is flying smoothly, praise them!" and ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"
                    end
                end
            elseif vehicleName == "Escaped Wilderling" then -- rare on korthia
                if GetTime() < lastWhisperTime + 0.5 then
                    if lastWhisper == "Escaped Wilderling gets a burst of speed. Hold on tight!" and ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    end
                end
            elseif vehicleName == "Borrhas the Cold" then
                if ActionCooldownRemains(134) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton2"
                elseif ActionCooldownRemains(133) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton1"
                end
            elseif vehicleName == "Majestic Runestag" then
                if UnitName("target") == "Dambala" then
                    if ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"
                    elseif ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"
                    elseif ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    end
                end
            elseif vehicleName == "Uther the Lightbringer" then
                -- wouldn't be surprised if I need to check zone or something for this
                local skip = false
                for guid,unit in upairs(WarGodUnit.groups.targetableOrPlates) do
                    if CheckInteractDistance(unit.unitid,3) then
                        if ActionCooldownRemains(135) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton3"
                            skip = true
                            break
                        elseif ActionCooldownRemains(134) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton2"
                            skip = true
                            break
                        end
                    end
                end
                if (not skip) and CheckInteractDistance("target",3) then
                    if ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    end

                end
            elseif vehicleName == "Veilwing Sentry" then
                if ActionCooldownRemains(133) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton1"
                end
            elseif vehicleName == "Anima Wyrm" then
                if ActionCooldownRemains(134) < 0.5 and player:BuffRemaining("Necrotic Surge", "HELPFUL") > 0 then
                    bestActionSoFar = "OverrideActionBarButton2"
                elseif ActionCooldownRemains(133) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton1"
                end
            elseif vehicleName == "Winged Soul Eater" then
                if GetTime() < lastWhisperTime + 0.5 then
                    if lastWhisper == "The Soul Eater writhes about. Pull the reins to tire it!" and ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"
                    elseif lastWhisper == "The Soul Eater tries to shake you off! Hold on tightly!" and ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"
                    elseif lastWhisper == "The Soul Eater tries to veer away. Give it a kick in the right direction!" and ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    end
                end
            elseif vehicleName == "Atleos" then
                if UnitName("target") == "Kraxis" then
                    if ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"
                    elseif ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"
                    elseif ActionCooldownRemains(136) < 0.5 and WarGod.Unit.vehicle.health_percent < 0.8 then
                        bestActionSoFar = "OverrideActionBarButton4"
                    elseif ActionCooldownRemains(137) < 0.5 and WarGod.Unit.vehicle.health_percent < 0.4 then
                        bestActionSoFar = "OverrideActionBarButton5"
                    elseif ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"

                    end
                end
            elseif vehicleName == "Kevin" then     -- Korthia quest thingy (fix name)
                if ActionCooldownRemains(134) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton2"
                elseif ActionCooldownRemains(133) < 0.5 and UnitExists("vehicletarget") then
                    bestActionSoFar = "OverrideActionBarButton1"

                end
            elseif vehicleName == "Disciple Kosmas" then        -- bastion story
                if ActionCooldownRemains(133) < 0.5--[[ and select(3, GetQuestObjectiveInfo(57446, 3, false)) == false]] then
                    bestActionSoFar = "OverrideActionBarButton1"
                end
            elseif vehicleName == "Moonfang" or zoneText == "Darkmoon Island" and UnitName("target") == "Moonfang" then
                if ActionCooldownRemains(133) < 0.5 then
                    print(vehicleName)
                    bestActionSoFar = "OverrideActionBarButton1"
                end
            elseif vehicleName == "Battlesewn Roc" then
                if GetTime() < lastWhisperTime + 0.5 then
                    if lastWhisper == "It is panicking! Use the riding hook to escape!" and ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"
                    end
                elseif ActionCooldownRemains(134) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton2"
                    -- using both abilities will kill the mobs before you can jump off
                    --elseif ActionCooldownRemains(135) < 0.5 then
                    --    bestActionSoFar = "OverrideActionBarButton3"
                end
            elseif vehicleName == "Ruby Whelpling" and zoneText == "The Waking Shores" then
                if ActionCooldownRemains(133) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton1"

                end

            elseif vehicleName == "Siege Scorpion" and zoneText == "Thaldraszus" then
                if ActionCooldownRemains(133) < 0.5 then
                    bestActionSoFar = "OverrideActionBarButton1"

                end

            elseif vehicleName == "Murloc Hopper" and zoneText == "Azmerloth" then
                if UnitExists("target") or UnitExists("vehicletarget") then
                    if ActionCooldownRemains(135) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton3"

                    elseif ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton2"

                    elseif ActionCooldownRemains(133) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton1"

                    end
                end
                --[[elseif vehicleName == "Tome of Spellflinging" and zoneText == "The Azure Span" then
                    if ActionCooldownRemains(134) < 0.5 then
                        bestActionSoFar = "OverrideActionBarButton4"
    
                    end]]


            elseif zoneText == "Korthia" then
                if UnitName("target") == "Nadjia the Mistblade" then
                    if GetTime() < lastWhisperTime + 0.5 then
                        if lastWhisper == "Lunge!" and ActionCooldownRemains(133) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton1"
                        elseif lastWhisper == "Parry!" and ActionCooldownRemains(134) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton2"
                        elseif lastWhisper == "Riposte!" and ActionCooldownRemains(135) < 0.5 then
                            bestActionSoFar = "OverrideActionBarButton3"
                        end
                    end
                end
            elseif zoneText == "The Waking Shores" and UnitName("target") == "Spawning Thresher" then
                print('hello')
                bestActionSoFar = "ExtraActionButton1"
            end
        else
            --print('hi')
            local forceCast, forceCastUnitId = GetForceCasts()
            if (forceCast) then
                --print(forceCast)
                bestActionSoFar = forceCast
                bestUnitIdSoFar = forceCastUnitId
                --player.queuedSpell = bestActionSoFar
                --player.queuedUnitId = bestUnitIdSoFar
                --bestLabelSoFar = "Forced"
            else
                if player.Setup then
                    player:Setup()
                end
                --local bestActionSoFar, bestUnitSoFar, bestScoreSoFar = "Nothing", "nounit", 0
                --print('bye')
                for spell,t in pairs(activeFrames) do
                    --local debug = true
                    if debug then print(spell) end
                    if not t.curScore then print(spell .. " has no current score") end
                    if not bestScoreSoFar then print(spell .. " has no bestScoreSoFar") end
                    if (t.curScore > bestScoreSoFar) then
                        if debug then print("b") end
                        --print(t:Ready())
                        if spell == "Nothing" or (t:Ready() and CDRemaining(t) < 0.3 and ReadyToCastNewSpell(t)) then
                            if debug then print("c") end
                            --if spell == "Loot-A-Rang" then print("d") end
                            if (not t.bestUnit) or t.bestUnitId == "player" or t.bestUnitId == "cursor" or (t.harm and IsValidEnemy(t, t.bestUnit ) or t.help and IsValidFriend(t, t.bestUnit ))--[[ and IsSpellInRange(spell, t.bestUnitId)]] then
                                --if spell == "Loot-A-Rang" then print("e") end
                                bestActionSoFar = spell
                                bestUnitIdSoFar = t.bestUnitId
                                bestScoreSoFar = t.curScore
                                bestUnitSoFar = t.bestUnit
                                --bestLabelSoFar = t.bestLabel
                            end
                            --[[else
                                bestActionSoFar = spell
                                bestUnitIdSoFar = t.bestUnitId
                                bestScoreSoFar = t.curScore
                                bestUnitSoFar = t.bestUnit
                            end]]
                        end
                    end
                end
                if (bestActionSoFar and bestActionSoFar ~= "Nothing") then
                    printTo(3, bestActionSoFar .. " @ " .. bestUnitIdSoFar .. " score " .. bestScoreSoFar .. " " .. (activeFrames[bestActionSoFar].conditions[bestScoreSoFar].label))
                    --[[for k,v in pairs(activeFrames[bestActionSoFar]) do
                        print(k)
                    end]]
                    --print(activeFrames[bestActionSoFar].conditions[bestScoreSoFar].label)
                    player.queuedSpell = bestActionSoFar
                    player.queuedUnitId = bestUnitIdSoFar
                    player.queuedGUID = bestUnitSoFar and bestUnitSoFar.guid
                end
            end
            --pixel.CastSpellViaCorrectPixel(bestActionSoFar .. bestUnitSoFar, bestActionSoFar, bestUnitSoFar)
            --print(bestScoreSoFar)
            --print(bestActionSoFar)
        end

        CastSpellViaCorrectPixel(bestActionSoFar .. bestUnitIdSoFar, bestActionSoFar, bestUnitIdSoFar)
        --curScore = bestScoreSoFar
    end

    updateFrame:SetScript("OnUpdate", function(self, elapsed)
        timeSinceLastUpdate = timeSinceLastUpdate + elapsed;
        if(timeSinceLastUpdate > updateDelay )then
            RefreshRotation()
        end

    end)

    updateFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "UNIT_SPELLCAST_STOP" then
            local unitId, lineId, spellId = ...
            if unitId == "player" then
                local spellName = GetSpellInfo(spellId)
                if spellName then
                    local frame = rawget(activeFrames, spellName)
                    if frame then
                        frame:RefreshSpell()
                    end
                end
                --print('stopped forcing refresh rotation')
                --RefreshRotation()
            end
        elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
            local timestamp, eventname, flagthatidunno, sourceguid, sourcename, sourceflags, sourceRaidFlags, destguid, destname, destflags, destRaidFlags,spellid, spellname, spellschool, typedetail, extraspellname = CombatLogGetCurrentEventInfo()
            if sourceguid == player.guid then
                if eventname == "SPELL_PERIODIC_DAMAGE" then
                    if player.channel == spellname then
                        local frame = rawget(activeFrames, spellname)
                        if frame then
                            frame:RefreshSpell()
                        end
                        --RefreshRotation()
                    end
                end
            end
        elseif event == "PLAYER_FOCUS_CHANGED" then
            RefreshRotation()
        elseif event == "CHAT_MSG_RAID_BOSS_WHISPER" or event == "CHAT_MSG_RAID_BOSS_EMOTE" or "CHAT_MSG_MONSTER_SAY" then
            local text = ...
            lastWhisper = text
            lastWhisperTime = GetTime()
            print(text)
        end

    end)
    updateFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
    updateFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    -----------------------------------------------------------
    updateFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
    updateFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
    updateFrame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
    --updateFrame:RegisterEvent("RAID_BOSS_WHISPER")
    --updateFrame:RegisterEvent("RAID_BOSS_EMOTE")
    
end
