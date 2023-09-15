modifier_pirate_poisoned_weapon_debuff = class({})

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:OnCreated( kv )
	self.movement_slow_percent = self:GetAbility():GetSpecialValueFor( "movement_slow_percent" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:OnRefresh( kv )
	self.movement_slow_percent = self:GetAbility():GetSpecialValueFor( "movement_slow_percent" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:OnIntervalThink()
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

function modifier_pirate_poisoned_weapon_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percent
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end