local Rotation = WarGod.Rotation
setfenv(1, Rotation)

-- 1. changes your activeFrames when you respec
-- 2. changes which auras you are known to be capable of dispeling
function Rotation:PLAYER_SPECIALIZATION_CHANGED(event, unitid)
    if unitid == "player" then
        local specId, specName = GetSpecializationInfo(GetSpecialization())
        if not specName then specName = "none" end
        --print(GetSpecializationInfo(spec))
        --local specName =
        if (specName) then
            activeFrames = rotationFrames[specName]

            for rotationSpecName,frameTable in pairs(rotationFrames) do
                if rotationSpecName ~= specName then
                    for k,v in pairs(frameTable) do
                        v:Hide()
                    end
                else
                    for k,v in pairs(frameTable) do
                        v:Show()
                    end
                end
            end
            for k,v in pairs(player.dispellableauratypes) do
                player.dispellableauratypes[k] = nil
            end
            if (specName == "Holy" or spec == "Restoration" or spec == "Mistweaver" or spec == "Discipline") then
                player.dispellableauratypes["Magic"] = true
            end
            local class = UnitClass("player")
            if (class == "Druid") then
                player.dispellableauratypes["Curse"] = true
                player.dispellableauratypes["Poison"] = true
            elseif (class == "Monk") then
                player.dispellableauratypes["Poison"] = true
                player.dispellableauratypes["Disease"] = true
            elseif (class == "Priest") then
                player.dispellableauratypes["Disease"] = true
            elseif (class == "Paladin") then
                player.dispellableauratypes["Disease"] = true
                player.dispellableauratypes["Poison"] = true
            elseif (class == "Shaman") then
                player.dispellableauratypes["Curse"] = true
            end
        end
    end
end
Rotation:PLAYER_SPECIALIZATION_CHANGED("PLAYER_SPECIALIZATION_CHANGED","player")

function Rotation:LFG_ROLE_UPDATE(event)
    Rotation:PLAYER_SPECIALIZATION_CHANGED(event,"player")
end
Rotation:RegisterEvent("LFG_ROLE_UPDATE")

function Rotation:UNIT_SPELLCAST_SUCCEEDED(event, unitid, lineid, spellid)
    if unitid == "player" then
        local spellName = GetSpellInfo(spellid)
        local spellFrame = rawget(activeFrames, spellName)
        if spellFrame then
            if spellFrame.offgcd then
                --print('forced refreshspell for ' .. spellName)
                --spellFrame:RefreshSpell()
                for k,v in pairs(activeFrames) do
                    if v.offgcd then
                        v:RefreshSpell()
                    end

                end
            else
                spellFrame:RefreshSpell()
            end

            -- maybe call generic RefreshRotation
            if notDebuggingRefresh then --[[print('refresh rotation b')]]RefreshRotation() end
        end
    end
end
Rotation:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

function Rotation:UNIT_SPELLCAST_START(event, unitid, lineid, spellid)
    if unitid == "player" then
        local spellName = GetSpellInfo(spellid)
        local spellFrame = rawget(activeFrames, spellName)
        if spellFrame then
            spellFrame:RefreshSpell()

            -- maybe call generic RefreshRotation
            if notDebuggingRefresh then --[[print('refresh rotation c`a ')]]RefreshRotation() end
        end
    end
end
Rotation:RegisterEvent("UNIT_SPELLCAST_START")