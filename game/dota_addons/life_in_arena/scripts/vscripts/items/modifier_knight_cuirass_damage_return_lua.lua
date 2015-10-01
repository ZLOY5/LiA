modifier_knight_cuirass_damage_return_lua = class ({})

--чтобы способность могла использовать этот модификатор в ней должен быть special value "damage_return"

function modifier_knight_cuirass_damage_return_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_knight_cuirass_damage_return_lua:IsHidden()
	return true
end

function modifier_knight_cuirass_damage_return_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end


function modifier_knight_cuirass_damage_return_lua:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) and not params.ranged_attack then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local damage_return_perc
			if self:GetParent():HasModifier("modifier_item_lia_knight_cuirass_ability") then
				damage_return_perc = self:GetAbility():GetSpecialValueFor("damage_return_abi")
			else
				damage_return_perc = self:GetAbility():GetSpecialValueFor("damage_return")
			end
			--print(damage_return_perc)

			local target = params.target
			local return_damage = damage_return_perc*0.01*params.damage
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = target, 
				damage = return_damage, 
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = params.ability
			})
		end
	end
end

