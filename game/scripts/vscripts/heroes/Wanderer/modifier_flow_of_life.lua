modifier_flow_of_life = class({})

function modifier_flow_of_life:IsBuff()
	return true 
end

function modifier_flow_of_life:GetEffectName()
	return "particles/wanderer_heal.vpcf"
end

function modifier_flow_of_life:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_flow_of_life:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
 
	return funcs

end

function modifier_flow_of_life:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_flow_of_life:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_flow_of_life:OnCreated(kv)
	if self:GetCaster():HasScepter() then
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen_scepter")
		self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen_scepter")
	else
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
		self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end	
end

function modifier_flow_of_life:OnRefresh(kv)
	if self:GetCaster():HasScepter() then
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen_scepter")
		self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen_scepter")
	else
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
		self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end	
end