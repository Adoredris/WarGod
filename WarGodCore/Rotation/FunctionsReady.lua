local Rotation = WarGod.Rotation
setfenv(1, Rotation)

local itemNamesToIds = {
    --["Potion of Spectral Intellect"] = 171273,
    ["Fleeting Elemental Potion of Ultimate Power"] = 191914,
    --["Fleeting Elemental Potion of Power"] = 191905,
    ["Fleeting Elemental Potion of Power"] = 191906,
    ["Elemental Potion of Power"] = 191389,
    ["Elemental Potion of Ultimate Power"] = 191382,
    --["Fleeting Elemental Potion of Power"] = 191907,
    --["Eternal Augment Rune"] = 190384,
    ["Loot-A-Rang"] = 60854,
}

local consumables = {[191905] = true}

function UnitRange(unit)
    --local minRange, maxRange = LRC:GetRange(unit.unitid)
    --return (minRange or 9000), (maxRange or 9001)
    return 45, 0
end

function ActionCooldownRemains(number)
    -- _ = no idea
    if number >= 133 and number <= 139 then number = number + 48 end        -- vehicle stuffs has been moved
    local start, duration, enabled_, enabled__ = GetActionCooldown(number)
    if start then
        return max(0, start + duration - GetTime())
    end
    return 0
end

function ItemCDRemaining(slotno)
    --/run printTo(3,GetInventoryItemCooldown("player",10))
    local start, duration, cdexists
    if slotno <= 18 then
        start, duration, cdexists = GetInventoryItemCooldown("player",slotno)
    else
        if (not consumables[slotno]) or GetItemCount(slotno) > 0 then
            start, duration, cdexists = GetItemCooldown(slotno)

        end
    end
    if(not cdexists)then
        print("BUG - SLOT : " .. slotno .. " CANNOT HAVE A CD")
        return GetTime() + 9999;
    end
    if(start==nil)then
        start=0;
        duration=0;
    end
    --if start + duration - GetTime() < 0.3 then print("ItemCDRemaining says ready") end
    return start + duration - GetTime()
end

function SpellCDRemaining(spellname)
    local t = GetSpellCooldown(spellname) or {}
    --decided non-existant spells should never pretend to be off cd, so now they don't.. fix any bugs that result
    if(t.startTime==nil)then
        t.startTime=GetTime() + 1337 --0;
        t.duration=1337 -- 0;
    end
    return t.startTime+t.duration-GetTime();
end

function CDRemaining(self)
    --local opt_SecondsFromNow = opt_SecondsFromNow or 0
    local spell = self.spell
    if(type(spell)=="number")then --printTo(3,"CDRemaining(item): " ..SpellOrItemNumber.." : " ..(ItemCDRemaining(SpellOrItemNumber) - opt_SecondsFromNow))
        return ItemCDRemaining(spell)
    elseif itemNamesToIds[spell] then
        if itemNamesToIds[spell] > 190000 then
            return max(ItemCDRemaining(itemNamesToIds[spell]), ItemCDRemaining(itemNamesToIds[spell] - 1), ItemCDRemaining(itemNamesToIds[spell] - 2))
        else
            return ItemCDRemaining(itemNamesToIds[spell])
        end
    else --printTo(3,"CDRemaining(spell): " ..SpellOrItemNumber.." : " ..(SpellCDRemaining(SpellOrItemNumber) - opt_SecondsFromNow))
        return SpellCDRemaining(spell)
    end
end

function SpellReady(self)
    --for k,v in pairs(self) do printTo(3,k) end
    --local readyTime = ...
    --printTo(3,self)
    --[[if now > self.readyTime - 0.3 then
        return true
    else]]if self:CDRemaining() < (--[[player.gcd or ]]0.3) then
        --print("CDRemaining says it's ready")      -- seems more reliable
        return true

    end
    --return now > self.readyTime - 0.2
end

function ItemReady(self)
    --for k,v in pairs(self) do printTo(3,k) end
    --local readyTime = ...
    --printTo(3,self)
    --[[if now > self.readyTime - 0.3 then
        return true
    else]]if self:CDRemaining() < (--[[player.gcd or ]]0.3) then
        --print("CDRemaining says it's ready")      -- seems more reliable
        return true

    end
    --return now > self.readyTime - 0.2
end

function ReadyToCastNewSpell(self)
    local casting,_,_,_,expires = UnitCastingInfo("player")
    if casting ~= nil then
        if (rawget(activeFrames, casting) and activeFrames[casting].Interrupt) then
            if activeFrames[casting].Interrupt(self) then
                --print('interrupting my cast')
                return true
            end
        end
        --local val = expires / 1000 - GetTime() < 0.2
        --print(val)
        return expires / 1000 - GetTime() < 0.5--math.max(0.2, select(4, GetNetStats()) / 1000 )
    end
    casting,_,_,_,expires = UnitChannelInfo("player")
    if casting ~= nil then
        if (rawget(activeFrames, casting) and activeFrames[casting].Interrupt) then
            if activeFrames[casting].Interrupt(self) then
                --print('interrupting my channel with ' .. self.spell)
                return true
            end
        end
        --if (--[[player.rotationSpells[casting] and ]](type(player.rotationSpells[casting].interrupt) == "function" and player.rotationSpells[casting]:interrupt() or player.rotationSpells[casting].interrupt == true)) then
        --return CDRemaining(casting) < math.max(select(4, GetNetStats()) / 1000, 0.3)--math.min(select(4, GetNetStats()) / 1000, 0.2)
        --end
        return expires / 1000 - GetTime() < max(select(4, GetNetStats()) / 1000, 0.2)--math.min(select(4, GetNetStats()) / 1000, 0.2)
    end
    return true
end