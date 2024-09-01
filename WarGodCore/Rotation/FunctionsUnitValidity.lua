local Rotation = WarGod.Rotation
local function IsItemInRange()
    print('please define a player.maxHarmRangeSpell')
    print('please define a player.maxHelpRangeSpell')
end

setfenv(1, Rotation)

function IsValidEnemy(self, unit, args)
    if unit.unitid == "" then --[[print('no unitid returning fail')]]return end
    -- 116139 is a 50 yard item
    if (--[[not self or self.harm and unit.harm and ]](not player.maxHarmRangeSpell and IsItemInRange(116139, unit.unitId) or player.maxHarmRangeSpell and IsSpellInRange(player.maxHarmRangeSpell, unit.unitId) == 1)) then
        --print('2')
        if (self.isCC or not Delegates:UnitIsBreakableCrowdControlled(self.spell, unit, args)) and not Delegates:DPSBlacklistWrapper(self.spell, unit, args) then
            --print('3')
            if ((unit.health_percent < 1 or unit.level > 0 and unit.level < player.level - 5 and select(4, GetInstanceInfo()) ~= "Timewalking" or UnitAffectingCombat(unit.unitid) or (not IsInInstance()) or select(2, GetDifficultyInfo(GetDungeonDifficultyID())) == "scenario" or GetNumGroupMembers() <= 1 or Delegates:DPSWhitelistWrapper(self.spell, unit, args))) then
                --print('4')
                --unit.valid = true
                return true
            end

        end
    end
    --print(unit.name and (unit.name .. ' is blacklisted'))
    --unit.valid = false
end

function IsValidFriend(self, unit, args)
    if unit.unitid == "" then return end
    if ((not player.maxHelpRangeSpell and IsItemInRange(34471, unit.unitId) or player.maxHelpRangeSpell and IsSpellInRange(player.maxHelpRangeSpell, unit.unitId) == 1)) then
        if not Delegates:FriendlyBlacklistWrapper(self.spell, unit, args) then
            --unit.valid = true
            return true

        end

    end
    --unit.valid = false
end

function UnitIdTooHigh(unitid)
    if strmatch(unitid, "^raid") then
        local num = tonumber(strsub(unitid, 5, 6))
        if num and num > 30 then
            return true
        end
    elseif strmatch(unitid, "^nameplate") then  -- nameplates getting there somehow
        return true
    end
end