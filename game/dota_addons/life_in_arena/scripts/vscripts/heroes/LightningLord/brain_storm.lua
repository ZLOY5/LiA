
function addMod(keys)
	--
	local ability = keys.ability
	local caster = keys.caster 	--hero
	local target = keys.target	--Target
	--
	--if not caster.tUnits then
	--	caster.tUnits = {}
	--end
	--
	--ability:ApplyDataDrivenModifier( caster, caster, 'modifier_decrepify_units_by_hero', {} )
	--for i=1, #caster.tUnits do
	--	if not caster.tUnits[i]:IsNull() then
	--		ability:ApplyDataDrivenModifier( caster, caster.tUnits[i], 'modifier_decrepify_units_by_hero', {} )
	--	end
	--end
	--
	if target:IsHero() then
		ability:ApplyDataDrivenModifier( caster, target, 'modifier_lol_decrepify_hero', {} )
	else
		ability:ApplyDataDrivenModifier( caster, target, 'modifier_lol_decrepify_other', {} )
	end
	--
end
