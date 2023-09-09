modifier_ghoul_persistence_effect = class({})

function modifier_ghoul_persistence_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_ghoul_persistence_effect:GetModifierConstantHealthRegen(params)
	if self:GetCaster():PassivesDisabled() then
		return 0
	end
	
	local t = CustomNetTables:GetTableValue("custom_modifier_state","GhoulPersistence"..tostring(self:GetCaster():entindex()))
	if not t then return end
	
	return self.regen_mult * t.str
end

function modifier_ghoul_persistence_effect:OnCreated( kv )
	self.regen_mult = self:GetAbility():GetSpecialValueFor( "regen_mult" )

	self:StartIntervalThink(0)
end

if IsServer() then
	function modifier_ghoul_persistence_effect:OnIntervalThink()
		CustomNetTables:SetTableValue("custom_modifier_state","GhoulPersistence"..tostring(self:GetCaster():entindex()),{str = self:GetCaster():GetBaseStrength()})
		return 0.1
	end
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence_effect:OnRefresh( kv )
	self.regen_mult = self:GetAbility():GetSpecialValueFor( "regen_mult" )
end
