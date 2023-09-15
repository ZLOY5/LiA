--[[Mana drain and damage part of Mana Break
	Author: Pizzalol
	Date: 16.12.2014.
	NOTE: Currently works on magic immune enemies, can be fixed by checking for magic immunity before draining mana and dealing damage]]
function ManaBreak( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local manaBurn = ability:GetSpecialValueFor("mana_per_hit")
	local manaDamage = ability:GetSpecialValueFor("damage_per_burn")

	if target:IsMagicImmune() or caster:PassivesDisabled() then
		return 
	end

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	damageTable.damage_flags = DOTA_UNIT_TARGET_FLAG_NONE -- Doesnt seem to work?

	-- Checking the mana of the target and calculating the damage
	if(target:GetMana() >= manaBurn) then
		damageTable.damage = manaBurn * manaDamage
		target:Script_ReduceMana(manaBurn, ability)
	else
		damageTable.damage = target:GetMana() * manaDamage
		target:Script_ReduceMana(manaBurn, ability)
	end

	target:EmitSound("Hero_Antimage.ManaBreak")
	ApplyDamage(damageTable)
end