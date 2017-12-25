
modifier_minotaur_demonic_power = class({})

function modifier_minotaur_demonic_power:IsHidden()
	return true
end

function modifier_minotaur_demonic_power:IsPurgable()
	return false
end

function modifier_minotaur_demonic_power:OnCreated(kv)
	self.cleave_start_radius = self:GetAbility():GetSpecialValueFor( "cleave_start_radius" )
	self.cleave_end_radius = self:GetAbility():GetSpecialValueFor( "cleave_end_radius" )
	self.cleave_distance = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	self.cleave_percent = self:GetAbility():GetSpecialValueFor( "cleave_percent" )
end

function modifier_minotaur_demonic_power:OnRefresh(kv)
	self.cleave_start_radius = self:GetAbility():GetSpecialValueFor( "cleave_start_radius" )
	self.cleave_end_radius = self:GetAbility():GetSpecialValueFor( "cleave_end_radius" )
	self.cleave_distance = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	self.cleave_percent = self:GetAbility():GetSpecialValueFor( "cleave_percent" )
end

function modifier_minotaur_demonic_power:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_minotaur_demonic_power:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.cleave_percent * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.cleave_start_radius, self.cleave_end_radius, self.cleave_distance, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	
	return 0
end