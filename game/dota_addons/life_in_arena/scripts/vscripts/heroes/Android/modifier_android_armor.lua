modifier_android_armor = class({}) 

function modifier_android_armor:IsHidden()
	return true 
end

function modifier_android_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR,
	}
 
	return funcs
end

function modifier_android_armor:OnCreated(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_android_armor:OnRefresh(kv)
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.minimumDamage = self:GetAbility():GetSpecialValueFor("min_damage")
end

function modifier_android_armor:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(params) 
	--PrintTable("GetModifierPhysical_ConstantBlockUnavoidablePreArmor",params)
	if params.inflictor then --не действует на физ урон от способностей
		return 0
	else 
		local newDamage = params.original_damage-self.damage_block
		if newDamage < 0 then 
			newDamage = 0 
		end
		
		if newDamage < self.minimumDamage then 
			return self.damage_block-(self.minimumDamage-newDamage)
		else 
			return self.damage_block 
		end
	end
end