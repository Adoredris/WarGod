local player = WarGod.Unit:GetPlayer()

local WGBM = WarGod.BossMods
local bossString = "Vectis"      -- not right at all
WGBM[bossString] = {}

local function DoingNormMax()
    local zone, type, diff, difficultyStr, maxSize = GetInstanceInfo()
    return diff == 14 or diff == 17
end

WGBM[bossString].Defensive = function(spell, unit, args)
    --print(...)
    --local spell, unit, args = ...
    local unitid = unit.unitid
    if (unit:AuraRemaining("Omega Vector", "HARMFUL") > 0) then
        return args[1] <= 12
    end
    --return 1337
end

WGBM[bossString].Taunt = function(spell, unit, args)
    local unitid = unit.unitid
    if unit.name == "Vectis" then
        if player:DebuffRemaining("Evolving Affliction", "HARMFUL") == 0 then
            if WarGod.Unit:GetUnit("boss1target"):DebuffRemaining("Evolving Affliction", "HARMFUL") > 0 then
                print("Should Taunt")
                --return true
            end
        end
    end
end

WGBM[bossString].Mitigation = function(spell, unit, args)
    --print('fetid mitigation')
    local bossThreat = UnitThreatSituation("player","boss1")
    if bossThreat and bossThreat >= 3 then
        return true
    end
end

WGBM[bossString].DPSBlacklist = function(spell, unit, args)
    --[[local unitid = unit.unitid
    local name = unit.name
    if (name == bossString and unit:AuraRemaining("Corrupt Aegis","boss1", nil, true) > 0) then
        return true
    elseif name == "Ember of Taeshalach" then
        if not DoingNormMax() then
            if DoingMythic() then
                if WarGodCore:AOEMode() then
                    return false
                end
            else
                return true
            end
        end
    end]]
end

WGBM[bossString].ExtraHealthMissing = function(spell, unit, args)
    local total = 0
    local unitid = unit.unitid
    for i = 1, 5 do
        local debuffName = UnitDebuff(unitid,i)
        if not debuffName then
            break
        end
        if debuffName == "Immunosuppression" then
            local amount = select(16, UnitDebuff(unitid, i))
            --print(amount)
            if type(amount) == "number" then
                total = total + amount
            end
        end
    end
    return total
    --local debuffName, _, _, _, _, _, _, _,_,_,_,_,_, _, _,absorbAmount = UnitDebuff("player",i)=="Immunosuppression"
    --/run for i=1,5 do if UnitDebuff("player",i)=="Immunosuppression" then print(select(16, UnitDebuff("player",i))) end end
end

WGBM[bossString].DPSWhitelist = function(spell, unit, args)
    local unitid = unit.unitid
    local name = unit.name
    if (name ~= bossString) then
        return true
    end
end

WGBM[bossString].Priority = function(spell, unit, args)
    local unitid = unit.unitid
    local score = 20
    local name = unit.name
    if name == bossString then
        score = 10
    else
        if unit.health_percent < 0.2 then
            score = 12
        else

        end
    end

    if UnitIsUnit(unitid, "target") then
        score = score + 5
    end
    return score, bossString
end