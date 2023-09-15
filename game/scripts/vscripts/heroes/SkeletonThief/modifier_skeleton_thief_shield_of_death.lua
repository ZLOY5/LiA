modifier_skeleton_thief_shield_of_death = class({})

function modifier_skeleton_thief_shield_of_death:IsHidden()
	return true
end

function modifier_skeleton_thief_shield_of_death:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_skeleton_thief_shield_of_death:OnAttackLanded(params)
	if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) and not params.ranged_attack then
		if self:GetParent():PassivesDisabled() then
			return 0
		end

		local damage_return = self:GetAbility():GetSpecialValueFor("damage_return")
		local chance_additional_damage = self:GetAbility():GetSpecialValueFor("chance_additional_damage")
		local additional_damage = self:GetAbility():GetSpecialValueFor("additional_damage")

		local target = params.target
		ApplyDamage(
		{
			victim = params.attacker, 
			attacker = target, 
			damage = damage_return, 
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = params.ability
		})

		if RollPercentage(chance_additional_damage) then
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = target, 
				damage = additional_damage, 
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = params.ability
			})
		end
	end
end