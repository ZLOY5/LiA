modifier_knight_dark_shield = class({})

function modifier_knight_dark_shield:IsHidden()
	return true
end

function modifier_knight_dark_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end


function modifier_knight_dark_shield:OnTakeDamage(params)
	if IsServer() then
		--print("input1")
		if params.unit == self:GetParent() and (not self:GetParent():IsIllusion()) and not (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) then
			--print("input2")
			if self:GetParent():PassivesDisabled() then
				return 0
			end
			--print("input3")

			local target = params.unit
			local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.damage
			--print("			params.damage = ", params.damage)
			--print("			return_damage = ", return_damage)
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