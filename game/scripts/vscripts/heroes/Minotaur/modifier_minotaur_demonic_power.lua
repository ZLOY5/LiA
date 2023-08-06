
modifier_minotaur_demonic_power = class({})

function modifier_minotaur_demonic_power:IsHidden()
	return true
end

function modifier_minotaur_demonic_power:IsPurgable()
	return false
end

function modifier_minotaur_demonic_power:OnCreated(kv)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
end

function modifier_minotaur_demonic_power:OnRefresh(kv)
	self.cleave_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
end

function modifier_minotaur_demonic_power:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
 
	return funcs
end

function modifier_minotaur_demonic_power:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if  not self.parent:IsIllusion()  then
			if self.parent:PassivesDisabled() then
				return 0
			end
			local damage = params.damage * self.cleave_percent / 100

			DoCleaveAttack_IgnorePhysicalArmor(self.parent,	params.target, self.ability, damage, self.radius_start, self.radius_end, self.radius_dist, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")
		end
	end
	
	return 0
end