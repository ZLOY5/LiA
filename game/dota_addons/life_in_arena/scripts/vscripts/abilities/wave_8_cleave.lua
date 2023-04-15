
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
	self.damage_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
end

--------------------------------------------------------------------------------

function modifier_wave_8_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_wave_8_cleave:GetModifierProcAttack_Feedback(params)
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
			local damage = params.damage * self.damage_percent / 100

			DoCleaveAttack_IgnorePhysicalArmor(self.parent,	params.target, self.ability, damage, self.radius_start, self.radius_end, self.radius_dist, "particles/custom/items/cleave.vpcf")
		end
	end
end

