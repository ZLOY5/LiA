
wave_8_cleave = class({})
LinkLuaModifier( "modifier_wave_8_cleave", "abilities/wave_8_cleave.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_8_cleave:GetIntrinsicModifierName()
	return "modifier_wave_8_cleave"
end

--------------------------------------------------------------------------------


modifier_wave_8_cleave = class({})

--------------------------------------------------------------------------------

function modifier_wave_8_cleave:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_8_cleave:OnCreated( kv )
	self.cleave_percent = self:GetAbility():GetSpecialValueFor( "cleave_percent" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

--------------------------------------------------------------------------------

function modifier_wave_8_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_8_cleave:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.cleave_percent * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.cleave_radius, self.cleave_radius, self.cleave_radius, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	
	return 0
end
