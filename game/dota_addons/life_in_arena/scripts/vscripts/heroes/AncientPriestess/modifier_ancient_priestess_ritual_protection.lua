modifier_ancient_priestess_ritual_protection = class({})

function modifier_ancient_priestess_ritual_protection:IsBuff()
	return true 
end

function modifier_ancient_priestess_ritual_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR,
	}
 
	return funcs
end

function modifier_ancient_priestess_ritual_protection:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(params)
	if IsServer() and self.record ~= params.record then 
		print("RITUAL PROTECTION: MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR")
		print("record",params.record)
		print("original_damage",params.original_damage)
		print("damage_absorb",self.damage_absorb)
		print("target",params.target)
		print("-------------------------------------------------------\n")

		self.record = params.record --без этого модификатор срабатывает несколько раз
		local parent = self:GetParent()

		local damage_block

		if self.damage_absorb > params.original_damage then 
			damage_block = params.original_damage
			self.damage_absorb = self.damage_absorb - damage_block
		else 
			damage_block = self.damage_absorb 
			self:Destroy()
		end

		self.damage_blocked = damage_block 

		return damage_block
	end
end

function modifier_ancient_priestess_ritual_protection:OnCreated(kv)
	self.damage_absorb = self:GetAbility():GetSpecialValueFor("damage_absorb")
end