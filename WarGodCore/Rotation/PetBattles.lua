

WarGod.Rotation.NeedToHealPets = function()
    local numPets, numOwned = C_PetJournal.GetNumPets()
    for i=1,numOwned do
        local petId = C_PetJournal.GetPetInfoByIndex(i)
        local isSlotted = C_PetJournal.PetIsSlotted(petId)
        if isSlotted then
            if C_PetJournal.PetIsHurt(petId) then
                return true
            end
        end
    end
end
