modifier_lord_of_lightning_brain_storm_debuff = class({})

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:OnCreated( kv )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:OnRefresh( kv )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:OnAttackLanded(params) 
	if params.target == self:GetParent() and params.attacker:GetAttackType() == "magic" then 
		local magicAttackParticle = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_end.vpcf", PATTACH_POINT, params.attacker)
		ParticleManager:SetParticleControlEnt(magicAttackParticle, 0, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true) 
	end 
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:GetEffectName()
	return "particles/custom/lightning_lord/lightning_lord_brain_storm_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:OnIntervalThink()
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

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percentage
end

--------------------------------------------------------------------------------

function modifier_lord_of_lightning_brain_storm_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end