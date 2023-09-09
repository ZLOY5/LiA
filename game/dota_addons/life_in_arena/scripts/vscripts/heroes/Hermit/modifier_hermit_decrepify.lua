modifier_hermit_decrepify = class({})

function modifier_hermit_decrepify:IsPurgable()
	return true
end

function modifier_hermit_decrepify:IsDebuff()
	return true
end

function modifier_hermit_decrepify:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
 
	return funcs
end

function modifier_hermit_decrepify:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
 
	return state
end


function modifier_hermit_decrepify:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_hermit_decrepify:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hermit_decrepify:OnCreated(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("reduce_spell_damage_pct")
	self.moveSpeedBonus = self:GetAbility():GetSpecialValueFor("reduce_movement_speed")
end


function modifier_hermit_decrepify:OnRefresh(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("reduce_spell_damage_pct")
	self.moveSpeedBonus = self:GetAbility():GetSpecialValueFor("reduce_movement_speed")
end

function modifier_hermit_decrepify:GetModifierMagicalResistanceDecrepifyUnique()
	return self.magicalResistance
end

function modifier_hermit_decrepify:GetModifierMoveSpeedBonus_Percentage()
	return self.moveSpeedBonus
end

function modifier_hermit_decrepify:GetModifierInvisibilityLevel()
	return 0.3*self:GetRemainingTime()/self:GetDuration()+0.3
end
