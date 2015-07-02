modifier_warrior_of_light_will_light = class({})

function modifier_warrior_of_light_will_light:IsHidden()
	return true
end

function modifier_warrior_of_light_will_light:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_warrior_of_light_will_light:OnTakeDamage(params)
	if IsServer() then
		--print(params.damage_flags,(params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION))
		-- (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) проверяет установлен ли флаг DOTA_DAMAGE_FLAG_REFLECTION
		if params.unit == self:GetParent() and (not self:GetParent():IsIllusion()) and not (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local damage_return = math.ceil((self:GetAbility():GetSpecialValueFor("absord_proc")*params.damage)-0.5)
			--print(damage_return)
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = params.unit, 
				damage = damage_return, 
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
			})
		end
	end
end