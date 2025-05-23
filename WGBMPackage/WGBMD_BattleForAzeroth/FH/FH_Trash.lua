---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Flora.
--- DateTime: 16/08/2018 12:33 PM
---

local WGBM = WarGod.BossMods

local bossString = "Freehold"
printTo(3,bossString)
WGBM[bossString] = {}

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if name == "Incorporeal Being" then return true end
    if WarGod.Rotation.Delegates:UnitIsBreakableCrowdControlled(spell, unit, args) then return true end

    return false
end


WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    --if (addSoon and WarGodU)
    local score = 10
    if name ~= bossString then
        score = 20
    end
    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
    --return WGBM.default.Priority(spell, unitid, args)
end

WGBM[bossString].Interrupt = function(spell, unit, args)
    local unitid = unit.unitid
    --print("checking interrupts on " .. unitid)
    if UnitCastingInfo(unitid) == "Painful Motivation" then
        print("skipping interrupts")
        return false
    end
    return true
end

WGBM[bossString].AllowedToInterrupt = function(spell, unit, args)
    local unitid = unit.unitid
    --print("checking interrupts on " .. unitid)
    local cast = UnitCastingInfo(unitid)
    if cast == "Lightning Bolt" then
        return
    end
    if cast == "Painful Motivation" then
        print("skipping interrupts")
        return false
    end
    return true
end

WGBM[bossString].Cleanse = function(spell, unit, args)
    local unitid = unit.unitid
    -- this is not actually the correct logic but oh well (really it's a "don't bother" type situation)
    if unit:BuffRemaining("Frost Blast", "HARMFUL") > 0 then
        return
    end
    return true
end

local ragingPurgeList = {
    --["Irontide Enforcer"] = true,         -- not stunnable
    --["Irontide Mastiff"] = true,          -- bestial wrath, bites
    --["Irontide Crackshot"] = true,        -- grenades
    --["Irontide Corsair"] = true,          -- stabs
    ["Irontide Bonesaw"] = true,            -- heals
    --["Freehold Pack Mule"] = true,
    --["Cutwater Duelist"] = true,          -- duelist dash
    --["Irontide Oarsman"] = true,              -- sea spout (stunnable?)
    --["Blacktooth Brute"] = true,            -- aoe splash
    ["Vermin Trapper"] = true,              -- traps
    --["Soggy Shiprat"] = true,
    ["Bilge Rat Padfoot"] = true,
    --["Blacktooth Scrapper"] = true,       -- blind rage
    ["Irontide Buccaneer"] = true,
    ["Bilge Rat Buccaneer"] = true,
    ["Bilge Rat Brinescale"] = true,
    --["Blacktooth Knuckleduster"] = true,
    --["Cutwater Knife Juggler"] = true,      -- Ricocheting Throw
    ["Cutwater Harpooner"] = true,            -- grip
    --["Irontide Crusher"] = true,
    ["Irontide Stormcaller"] = true,        -- thundering squall
    --["Irontide Ravager"] = true,        -- painful motivation
    ["Irontide Officer"] = true,        -- painful motivation / oiled blade (oiled blade is dangerous)
    ["Bilge Rat Swabby"] = true,        -- slippery suds
    --["Freehold Deckhand"] = true,
    --["Freehold Shipmate"] = true,
    --["Freehold Barhand"] = true,
    --["Shiprat"] = true,
}

WGBM[bossString].Purge = function(spell, unit, args)
    --print('checking purge')
    local unitid = unit.unitid
    local name = unit.name
    local class = UnitClass("player")
    if class == "Druid" or class == "Rogue" or class == "Hunter" then
        --[[if unit:BuffRemaining("Painful Motivation", "HELPFUL") > 0 then
            print('do not dispel painful motivation')
            return
        end]]
        local dispelScore = 0
        for i=1,40 do
            local t = UnitBuff(unitid, i)
            if not t then break end--if (buffType) then print(buffType) end
            if (t.dispelName == "Enrage" or t.dispelName == "")then -- apparently enrages are empty string (still true?)
                if t.name == "Enrage" then
                    if ragingPurgeList[name] then
                        dispelScore = dispelScore + 1
                    end
                elseif t.name == "Painful Motivation" then
                    print('not dispelling with painful motivation')
                    return
                else
                    dispelScore = dispelScore + 1
                end

            end

        end
        if dispelScore > 0 then
            return true
        end
    else
        return true
    end
end