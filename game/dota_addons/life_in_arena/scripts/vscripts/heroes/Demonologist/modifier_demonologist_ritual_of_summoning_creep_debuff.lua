modifier_demonologist_ritual_of_summoning_creep_debuff = class({})

function modifier_demonologist_ritual_of_summoning_creep_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:IsHidden()
	return true
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:IsPurgable()
	return false
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:OnCreated(kv)
	if IsServer() then
		self.remainder = 0
		self.health_loss_interval = self:GetAbility():GetSpecialValueFor( "health_loss_interval" )
		self.max_health_loss_percent_per_second = self:GetAbility():GetSpecialValueFor( "max_health_loss_percent_per_second" )

		self:StartIntervalThink( self.health_loss_interval )
	end
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:OnIntervalThink()
	if IsServer() then
		local max_health = self:GetParent():GetMaxHealth()
		local current_health = self:GetParent():GetHealth()
		local damage_to_deal = max_health * self.max_health_loss_percent_per_second * self.health_loss_interval / 100
		local damage_floor = math.floor(damage_to_deal)
		self.remainder = self.remainder + (damage_to_deal - damage_floor)
		if self.remainder >= 1.0 then
			damage_floor = damage_floor + 1.0
			self.remainder = self.remainder - 1.0
		end
		self.new_health_value = current_health - damage_floor
		self:GetParent():ModifyHealth(self.new_health_value, self:GetAbility(), true, 0)

	end
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_demonologist_ritual_of_summoning_creep_debuff:StatusEffectPriority()
	return 10
end