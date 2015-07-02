modifier_knight_shield_damage_return_lua = class ({})

--чтобы способность могла использовать модификатор в ней должен быть special value "damage_return"

function modifier_knight_shield_damage_return_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_knight_shield_damage_return_lua:IsHidden()
	return true
end

function modifier_knight_shield_damage_return_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end


function modifier_knight_shield_damage_return_lua:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) and not params.ranged_attack then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.damage
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = target, 
				damage = return_damage, 
				damage_type = DAMAGE_TYPE_MAGICAL
			})
		end
	end
end

