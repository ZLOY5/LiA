
function addMod(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local target = keys.target
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
		ability:ApplyDataDrivenModifier( caster, target, 'modifier_decrepify_hero', {} )
	else
		ability:ApplyDataDrivenModifier( caster, target, 'modifier_decrepify_other', {} )
	end
	--
end

--[[function attackLanded(keys)
	--
	local ability = keys.ability
	--local caster = keys.caster --hero
	local attacker = keys.attacker
	local dmg = attacker:GetAverageTrueAttackDamage()
	local target = keys.target
	--print(dmg)
	--
	if target:HasModifier("modifier_decrepify_hero") or target:HasModifier("modifier_decrepify_other") then
		local damageTable = {
						victim = target,
						attacker = attacker,
						damage = dmg,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = keys.ability
							}
		ApplyDamage(damageTable)
	end
	--
end
]]

