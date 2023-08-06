modifier_warrior_of_light_holy_power = class({})

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:OnCreated( kv )
	self.block_chance = self:GetAbility():GetSpecialValueFor( "block_chance" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.block_chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:OnRefresh( kv )
	self.block_chance = self:GetAbility():GetSpecialValueFor( "block_chance" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.block_chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_warrior_of_light_holy_power:GetModifierPhysical_ConstantBlock(params)
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return
		end

		if not params.inflictor and self.pseudo:Trigger() then 
			return params.original_damage 
		end
	end
end

--------------------------------------------------------------------------------

