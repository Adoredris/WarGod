local Rotation = WarGod.Rotation
setfenv(1, Rotation)

local function FrameOnUpdate(self, elapsed)
    self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
    if(self.timeSinceLastUpdate > self.updateDelay )then
        self:RefreshSpell()
    end
end


function AddSpell(spec, spell, t)
    if not spec then
        for k,v in pairs(rotationFrames) do
            AddSpell(k, spell,  t)
        end
        return
    end
    local self = rotationFrames[spec][spell]
    self.spec = spec
    self.spell = spell
    local helpharm = t.helpharm
    self.maxRange = (t.maxRange and t.maxRange or player.maxRange or 40)
    self.minRange = (t.minRange and t.minRange or 0)
    if (t.maxRange and t.maxRange > player.maxRange) then
        player.maxRange = t.maxRange
    end
    if helpharm == "helpharm" then
        self.help = true
        self.harm = true
    elseif helpharm == "help" then
        self.help = true
    elseif helpharm == "harm" then
        self.harm = true
    end

    if (t.scorer == nil) then
        if (self.harm)then
            self.scorer = Delegates.PriorityWrapper
        elseif (self.help) then
            self.scorer = Delegates.FriendlyPriorityWrapper
        end
    end

    self.curScore = 0

    self.Ready = self.Ready or t.Ready or SpellReady
    self.CDRemaining = CDRemaining
    self.Interrupt = t.Interrupt or self.Interrupt

    self.maxScore = self.maxScore or 0       -- this will be used to suspend the onupdate of this frame by comparing to current overall maxScore
    self.castWhileCasting = t.castWhileCasting
    self.needNotFace = self.needNotFace or t.needNotFace
    self.isCC = self.isCC or t.isCC
    self.cc = self.cc or t.cc              -- can cast during these cc
    self.notcc = self.notcc or t.notcc        -- can't cast during these cc (only needed for the cc that doesn't normally prevent casts)
    self.IsUsable = t.IsUsable or t.usabilityFunc or self.IsUsable or AlwaysTrue        -- flat out unable to cast it atm
    self.Castable = t.Castable--[[ and t.Castable]] or self.Castable or AlwaysTrue            -- conditions that SUGGEST you should shouldn't cast it atm
    self.rez = self.rez or t.rez
    if not self.conditions then self.conditions = {} end

    self.timeSinceLastUpdate = 0
    self.quick = self.quick or t.quick
    self.offgcd = self.offgcd or t.offgcd
    self.updateDelay = random(50,100) * (self.quick and 0.005 or 0.01)
    self.RefreshSpell = RefreshSpell
    self:SetScript("OnUpdate", FrameOnUpdate)
end

function AddItem(spec, spell, t)
    if not spec then
        for k,v in pairs(rotationFrames) do
            AddItem(k, spell,  t)
        end
        return
    end
    local self = rotationFrames[spec][spell]
    self.spec = spec
    self.spell = spell
    local helpharm = t.helpharm
    self.maxRange = (t.maxRange and t.maxRange or player.maxRange or 40)
    self.minRange = (t.minRange and t.minRange or 0)
    if (t.maxRange and t.maxRange > player.maxRange) then
        player.maxRange = t.maxRange
    end
    if helpharm == "helpharm" then
        self.help = true
        self.harm = true
    elseif helpharm == "help" then
        self.help = true
    elseif helpharm == "harm" then
        self.harm = true
    end
    self.curScore = 0

    if (t.scorer == nil) then
        if (self.harm)then
            self.scorer = Delegates.PriorityWrapper
        elseif (self.help) then
            self.scorer = Delegates.FriendlyPriorityWrapper
        end
    end

    self.Ready = self.Ready or t.Ready or SpellReady
    self.CDRemaining = CDRemaining
    self.Interrupt = t.Interrupt or self.Interrupt

    self.maxScore = self.maxScore or 0       -- this will be used to suspend the onupdate of this frame by comparing to current overall maxScore
    self.castWhileCasting = t.castWhileCasting
    self.needNotFace = self.needNotFace or t.needNotFace
    self.isCC = self.isCC or t.isCC
    self.cc = self.cc or t.cc              -- can cast during these cc
    self.notcc = self.notcc or t.notcc        -- can't cast during these cc (only needed for the cc that doesn't normally prevent casts)
    self.IsUsable = t.IsUsable or t.usabilityFunc or self.IsUsable or AlwaysTrue        -- flat out unable to cast it atm
    self.Castable = t.Castable--[[ and t.Castable]] or self.Castable or AlwaysTrue            -- conditions that SUGGEST you should shouldn't cast it atm
    self.rez = self.rez or t.rez
    if not self.conditions then self.conditions = {} end

    self.timeSinceLastUpdate = 0
    self.quick = self.quick or t.quick
    self.offgcd = self.offgcd or t.offgcd
    --self.updateDelay = random(50,100) * (self.quick and 0.001 or 0.005)
    self.updateDelay = random(50,100) * (self.quick and 0.01 or 0.05)
    self.RefreshSpell = RefreshSpell
    self:SetScript("OnUpdate", FrameOnUpdate)
end

function AddSpellFunction(spec, spell, score, t)
    if (spec == nil) then
        for k,v in pairs(rotationFrames) do AddSpellFunction(k, spell, score, t) end
        return
    end
    AddSpell(spec, spell, t)
    local parent = rotationFrames[spec][spell]
    local self = {}

    self.label = t.label or spell
    self.func = t.func or AlwaysTrue
    self.units = t.units
    self.andDelegates = t.andDelegates or AlwaysTrue
    self.args = t.args or {}

    self.BestTargetFunc = t.BestTargetFunc or AlwaysTrue
    if (score > parent.maxScore) then
        parent.maxScore = score
    end


    parent.conditions[score] = self

    if (t.scorer ~= nil) then
        self.scorer = t.scorer
    end
end

function AddItemFunction(spec, spell, score, t)
    if (spec == nil) then
        for k,v in pairs(rotationFrames) do AddItemFunction(k, spell, score, t) end
        return
    end
    AddItem(spec, spell, t)
    local parent = rotationFrames[spec][spell]
    local self = {}

    self.label = t.label or spell
    self.func = t.func or AlwaysTrue
    self.units = t.units
    self.andDelegates = t.andDelegates or AlwaysTrue
    self.args = t.args or {}
    if (t.scorer == nil) then
        if (parent.harm)then
            self.scorer = Delegates.PriorityWrapper
        elseif (parent.help) then
            self.scorer = Delegates.FriendlyPriorityWrapper
        end
    else
        self.scorer = t.scorer
    end
    self.BestTargetFunc = t.BestTargetFunc or AlwaysTrue
    if (score > parent.maxScore) then
        parent.maxScore = score
    end


    parent.conditions[score] = self

end