local Rotation = WarGod.Rotation
setfenv(1, Rotation)

function InTravelForm()
    if UnitClass("player") ~= "Druid" then return end
    local formIndex = GetShapeshiftForm()
    if (not formIndex) then
        return
    elseif formIndex == 3 then
        return true
    elseif formIndex >= 4 then
        if select(4, GetShapeshiftFormInfo(formIndex)) == 210053 then
            return true
        end
    end
end

function IsNonCombatMounted()
    if IsMounted() then
        if player:BuffRemaining("Glimmerhoof Kirin","HELPFUL") == 0 then
            player.lastMountedTime = GetTime()
            return true
            --elseif
        end
    elseif InTravelForm() then
        player.lastMountedTime = GetTime()
        return true
    elseif UnitInVehicle("player") then
        for i=1,UnitVehicleSeatCount("player") do
            local controlType, occupantName, occupantRealm, canEject, canSwitchSeats = UnitVehicleSeatInfo("player", i)
            if occupantName == UnitName("player") then
                if controlType == "None" then
                    -- there may be other exceptions, but I'll come up with them later
                    --[[if (StringInGroupOfStrings(UnitName("vehicle"), LegendaryIdiots)) then
                        return true
                    else
                        return false
                    end]]

                else
                    return false
                end
            end
        end
    end

    return false
end