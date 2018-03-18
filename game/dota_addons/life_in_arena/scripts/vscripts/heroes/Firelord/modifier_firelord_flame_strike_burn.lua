modifier_firelord_flame_strike_burn = class({})

function modifier_firelord_flame_strike_burn:IsDebuff()
	return true
end

if IsServer() then

	function modifier_firelord_flame_strike_burn:OnCreated(kv)
		self:StartIntervalThink(1)
	end

	function modifier_firelord_flame_strike_burn:OnIntervalThink()
		ApplyDamage({
			victim = self:GetParent(), 
			attacker = self:GetCaster(), 
			damage = self:GetAbility():GetSpecialValueFor("burn_dps"), 
			damage_type = DAMAGE_TYPE_MAGICAL, 
			ability = self:GetAbility()
		})
	end

end
