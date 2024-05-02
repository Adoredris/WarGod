--
-- Created by IntelliJ IDEA.
-- User: Adoredris
-- Date: 12/02/2017
-- Time: 5:54 PM
-- To change this template use File | Settings | File Templates.
--
local WGBM = WarGod.BossMods
local bossString = "Halondrus the Reclaimer"
WGBM[bossString] = {}

WGBM[bossString].Defensive = function(spell, unit, args)
    local unitid = unit.unitid
    local now = GetTime()
    if args[2] <= 60 then

        if WarGod.Unit:GetPlayer():DebuffRemaining("Earthbreaker Missiles","HARMFUL") > 0 then
            return true
        --elseif WarGod.Unit:GetPlayer():DebuffRemaining("Crushing Prism","HARMFUL") > 0 then
        --    return true
        end
        --[[for msg,time in pairs(WGBM.timers) do
            local timeDiff = time - now
            if timeDiff < -1 and timeDiff > -6 then
                if strmatch(msg, "Meteor") then
                    --for guid,unit in upairs(WarGod.Unit.groups.help) do
                    --    remains =  unit:DebuffRemaining("Frost Blast","HARMFUL")
                    --    if remains > 0 and remains < 2 then
                    return true
                    --    end
                    --end
                end
            end
        end]]
    end
    --return 1337
end

WGBM[bossString].DamageCD = function(spell, unit, args)
    if (not DoingMythic()) then return true end
    if args[2] >= 300 then
        return WarGod.Unit:GetPlayer():TimeInCombat() > 200
    else
        return true
    end
end