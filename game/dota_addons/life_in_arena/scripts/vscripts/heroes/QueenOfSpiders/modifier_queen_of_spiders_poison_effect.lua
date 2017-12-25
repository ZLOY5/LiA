modifier_queen_of_spiders_poison_effect = class({})

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:OnCreated( kv )
	self.tick_time = self:GetAbility():GetSpecialValueFor( "tick_time" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

	if IsServer() then
		self:StartIntervalThink(self.tick_time)
	end
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:OnRefresh( kv )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_effect:OnIntervalThink()
	if IsServer() then

		if self:GetCaster():PassivesDisabled() then
			return
		end

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_per_second * self.tick_time,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end