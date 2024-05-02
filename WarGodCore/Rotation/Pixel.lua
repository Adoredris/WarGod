local size = 10


local WarGod = WarGod
--WarGod.Pixel = pixel
setfenv(1, WarGod.Rotation)

local pixel = CreateFrame("Frame", nil, UIParent)
pixel:SetFrameStrata ("TOOLTIP")
pixel:SetWidth (size)
pixel:SetHeight (size)
--pixel:SetWidth (20)
--pixel:SetHeight (20)
local pixelColour = pixel:CreateTexture ()
pixelColour:SetColorTexture (1, 1, 1)
pixelColour:SetAllPoints (pixel)
pixel.texture = pixelColour pixel:SetPoint ("TOPLEFT", 0, 0) pixel:Show ()

local backupPixel = CreateFrame("Frame", nil, UIParent)
backupPixel:SetFrameStrata ("TOOLTIP")
backupPixel:SetWidth (size)
backupPixel:SetHeight (size)
--local backupPixelColour = pixel:CreateTexture (nil, "TOOLTIP")
local backupPixelColour = pixel:CreateTexture ()
backupPixelColour:SetColorTexture (1, 1, 1)
backupPixelColour:SetAllPoints (backupPixel)
backupPixel.texture = pixelColour backupPixel:SetPoint ("TOPRIGHT", 0, 0) backupPixel:Show ()

local lastSpell, lastUnitId = "", ""

local magicRed = 137 / 255

local function FindAndSetPixelFor(spell, unitid)
    local Keystroke, BlueModifier, RedModifier, RedCapable, KeybindUsed = WarGod.Binder.GetValuesForSpellUnit (spell, unitid)

    pixelColour:SetColorTexture (magicRed, BlueModifier / 255, Keystroke / 255);
    backupPixelColour:SetColorTexture (magicRed, BlueModifier / 255, Keystroke / 255);
end


function CastSpellViaCorrectPixel(spellUnit,spell,unitId)
    if (not spell or spell == "Nothing") then
        if (lastSpell ~= spell) then
            lastSpell = spell
            lastUnitId = unitId
            pixelColour:SetColorTexture (0, 0, 0);
            backupPixelColour:SetColorTexture (0, 0, 0);
        end
    else
        --local debugspam = true

        if (lastSpell ~= spell or lastUnitId ~= unitId) then
            lastSpell = spell
            lastUnitId = unitId
            if UpdateCastData_AttemptToCastAt then UpdateCastData_AttemptToCastAt(spell,unitId) end
            --if spell == "OverrideActionBarButton1" then print('hello wtf is going on') end
            FindAndSetPixelFor (spell, unitId);
        end
    end
end

print('pixel.lua loaded successfully')