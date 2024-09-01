local Rotation = WarGod.Rotation
setfenv(1, Rotation)

function AlwaysTrue()
    return true
end

function AllTrue(spellname, unitid, args, t)
    for k,func in pairs(t) do
        if (not func(t, spellname, unitid, args)) then
            --if (not t[k](spellname, unitid, args)) then
            return
        end
    end
    return true
end

--IsEnemyDelegateTable = {Delegates.UnitIsEnemy}
--IsFriendDelegateTable = {Delegates.UnitIsFriend}

function LustRemaining()
    local lustRemains = max(player.buffAnyone.time_warp:Remains(),
            player.buffAnyone.primal_rage:Remains(),
            player.buffAnyone.heroism:Remains(),
            player.buffAnyone.bloodlust:Remains(),
            player.buffAnyone.fury_of_the_aspects:Remains())
    return lustRemains
end

function SatedRemaining()
    local satedRemains = max(player.debuffAnyone.sated:Remains(),
            player.debuffAnyone.exhaustion:Remains(),
            player.debuffAnyone.temporal_displacement:Remains(),
            player.debuffAnyone.fatigued:Remains())
    return satedRemains
end