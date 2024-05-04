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

IsEnemyDelegateTable = {Delegates.UnitIsEnemy}
IsFriendDelegateTable = {Delegates.UnitIsFriend}

function LustRemaining()
    --[[for i=1,40 do
        local name, _, _, _, duration, expiresAt, _, _, _, spellId = UnitBuff("player", i)
        if not spellId then return 0 end
        if (spellId == 80353                -- time warp
                or spellId == 264667        -- primal rage
                or spellId == 32182   -- heroism
                or spellId == 2825 -- bloodlust
                or spellId == 390386) then  -- evoker hero
            return expiresAt - GetTime()
        elseif (spellId == 309658) then     -- drums
            return expiresAt - GetTime()
        end
    end]]
    local lustRemains = max(player.buff.time_warp:Remains(),
            player.buff.primal_rage:Remains(),
            player.buff.heroism:Remains(),
            player.buff.bloodlust:Remains(),
            player.buff.fury_of_the_aspects:Remains())
    return lustRemains
end