modifier_android_armor = class({}) 

function modifier_android_armor:IsHidden()
	return true 
end

function modifier_android_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
 
	return funcs
end

function modifier_android_armor:OnCreated(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.minimumDamage = self:GetAbility():GetSpecialValueFor("min_damage")
end

function modifier_android_armor:OnRefresh(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.minimumDamage = self:GetAbility():GetSpecialValueFor("min_damage")
end

function modifier_android_armor:GetModifierPhysical_ConstantBlock(params) 
	if self:GetParent():PassivesDisabled() then
		return 0	
	end
	
	if not params.inflictor then
		if (params.original_damage - self.damage_block) <= self.minimumDamage then 
			return params.original_damage
		else 
			return self.damage_block 
		end
	end
end
