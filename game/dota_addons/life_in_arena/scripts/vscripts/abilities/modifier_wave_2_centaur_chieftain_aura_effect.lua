modifier_wave_2_centaur_chieftain_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura_effect:OnCreated( kv )
	self.bonus_movement_speed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed_percentage" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura_effect:OnRefresh( kv )
	self.bonus_movement_speed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed_percentage" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end


--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura_effect:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_movement_speed_percentage
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura_effect:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

