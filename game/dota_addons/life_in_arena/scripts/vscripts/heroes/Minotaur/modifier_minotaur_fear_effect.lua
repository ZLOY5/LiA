
modifier_minotaur_fear_effect = class({})


function modifier_minotaur_fear_effect:IsHidden()
	return false
end

function modifier_minotaur_fear_effect:IsPurgable()
	return false
end

if IsServer() then
	function modifier_minotaur_fear_effect:OnCreated(kv)
	
		self.base_armor_reduction = self:GetAbility():GetSpecialValueFor("base_armor_reduction")
		self.armor_reduction_per_spirit = self:GetAbility():GetSpecialValueFor("armor_reduction_per_spirit")
		self.illusion_multiplier = 0
		self.additional_armor_reduction = 0
		if self:GetCaster().guardian_spirits ~= nil and not self:GetCaster():IsIllusion() then
			self.additional_armor_reduction = self.base_armor_reduction + self.armor_reduction_per_spirit * #self:GetCaster().guardian_spirits
		else
			self.additional_armor_reduction = self.base_armor_reduction
		end
		self:SetStackCount(self.additional_armor_reduction)
	end	
end

if IsServer() then
	function modifier_minotaur_fear_effect:OnRefresh(kv)
	
		self.base_armor_reduction = self:GetAbility():GetSpecialValueFor("base_armor_reduction")
		self.armor_reduction_per_spirit = self:GetAbility():GetSpecialValueFor("armor_reduction_per_spirit")
		self.illusion_multiplier = 0
		self.additional_armor_reduction = 0
		if self:GetCaster().guardian_spirits ~= nil then
			self.additional_armor_reduction = self.base_armor_reduction + self.armor_reduction_per_spirit * #self:GetCaster().guardian_spirits
		else
			self.additional_armor_reduction = self.base_armor_reduction
		end
		self:SetStackCount(self.additional_armor_reduction)
	end	
end

function modifier_minotaur_fear_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_minotaur_fear_effect:GetModifierPhysicalArmorBonus()
		if self:GetCaster():PassivesDisabled() then
			return 0
		end

		return self:GetStackCount()
end

