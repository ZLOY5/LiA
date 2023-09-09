modifier_vampire_transformation_regen = class({})

function modifier_vampire_transformation_regen:IsHidden()
	return true
end 

function modifier_vampire_transformation_regen:IsPurgable()
	return true
end 

function modifier_vampire_transformation_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_vampire_transformation_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_vampire_transformation_regen:GetModifierConstantHealthRegen(params)
	--print((self:GetCaster().thirst_points or 0)*self.tp_regen_mult)
	return (self:GetCaster().thirst_points or 0)*self.tp_regen_mult
end

function modifier_vampire_transformation_regen:OnCreated(params)
	local ability = self:GetAbility()
	if ability then
		self.tp_regen_mult = ability:GetSpecialValueFor("tp_regen_mult")
	end
end