modifier_demonologist_demonic_seal_debuff = class({})

function modifier_demonologist_demonic_seal_debuff:IsHidden()
	return false
end

function modifier_demonologist_demonic_seal_debuff:IsPurgable()
	return true
end

function modifier_demonologist_demonic_seal_debuff:OnCreated(kv)
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self.initial_damage = self:GetAbility():GetSpecialValueFor( "initial_damage_scepter" )
			self.additional_damage = self:GetAbility():GetSpecialValueFor( "additional_damage_scepter" )
		else
			self.initial_damage = self:GetAbility():GetSpecialValueFor( "initial_damage" )
			self.additional_damage = self:GetAbility():GetSpecialValueFor( "additional_damage" )
		end

		self.damage_multiplier = 1

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.initial_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )

		self:StartIntervalThink( 1 )
	end
end

function modifier_demonologist_demonic_seal_debuff:GetEffectName()
	return "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_debuff.vpcf"
end

function modifier_demonologist_demonic_seal_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_demonologist_demonic_seal_debuff:OnIntervalThink()
	if IsServer() then
		self.damage_to_deal = self.initial_damage + self.additional_damage * self.damage_multiplier
		self.damage_multiplier = self.damage_multiplier + 1
		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )

	end
end