modifier_android_armor = class({}) 

function modifier_android_armor:IsHidden()
	return true 
end

function modifier_android_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
	}
 
	return funcs
end

function modifier_android_armor:OnCreated(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_android_armor:OnRefresh(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_android_armor:GetDisableAutoAttack(params) 
	PrintTable("GetDisableAutoAttack",params)
	if self:GetParent():GetHealthPercent() == 100 then
		return 1 
	else 
		return 0
	end
end