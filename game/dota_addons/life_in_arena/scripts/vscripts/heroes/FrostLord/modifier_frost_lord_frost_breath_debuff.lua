modifier_frost_lord_frost_breath_debuff = class({})

function modifier_frost_lord_frost_breath_debuff:IsHidden()
	return false
end

function modifier_frost_lord_frost_breath_debuff:IsPurgable()
	return true
end

function modifier_frost_lord_frost_breath_debuff:OnCreated(kv)
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second_scepter" )
		else
			self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		end

		self:StartIntervalThink( 1 )
	end
end

function modifier_frost_lord_frost_breath_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_frost_lord_frost_breath_debuff:StatusEffectPriority()
	return 10
end

function modifier_frost_lord_frost_breath_debuff:OnIntervalThink()
	if IsServer() then
		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_per_second,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end