modifier_troll_cutthroat_battle_trance = class({})

function modifier_troll_cutthroat_battle_trance:IsHidden()
	return false
end

function modifier_troll_cutthroat_battle_trance:IsPurgable()
	return false
end

function modifier_troll_cutthroat_battle_trance:OnCreated(kv)
	self.caster = self:GetParent()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	if IsServer() then
		self.caster:ModifyStrength(self.bonus_strength)
		self.caster:CalculateStatBonus(true)
	
		self.whirl = self.caster:FindAbilityByName("troll_cutthroat_enchanted_axes")
		if self.whirl ~= nil then
			self.whirl:SetActivated(true)
		end
	end
end

function modifier_troll_cutthroat_battle_trance:OnDestroy()
	if IsServer() then
		self.caster:ModifyStrength(-self.bonus_strength)
		self.caster:CalculateStatBonus(true)
	
		if self.whirl ~= nil and not self.caster:HasModifier("modifier_troll_cutthroat_battle_trance") and not self.caster:HasModifier("modifier_troll_cuthroat_boomeang_axe_disarm") then
			self.whirl:SetActivated(false)
		end	
	end
end

function modifier_troll_cutthroat_battle_trance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_troll_cutthroat_battle_trance:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_troll_cutthroat_battle_trance:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_troll_cutthroat_battle_trance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end