function CalcRegeneration(event)
 local unit = event.target
if not unit.base_regen then
unit.base_regen = unit:GetBaseHealthRegen()
end
 unit:SetBaseHealthRegen( unit.base_regen*(1 + 0.01*event.ability:GetSpecialValueFor("regen_percent")))
end


function AuraNone(event)
 local unit = event.target
	if not unit:HasModifier("orb_of_frost_aura_armor") and not unit:HasModifier("horn_aura_armor") then
		unit:SetBaseHealthRegen(unit.base_regen)
		end
end