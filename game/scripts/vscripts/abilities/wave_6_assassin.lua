
wave_6_assassin = class({})
LinkLuaModifier( "modifier_wave_6_assassin", "abilities/wave_6_assassin.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_6_assassin:GetIntrinsicModifierName()
	return "modifier_wave_6_assassin"
end

--------------------------------------------------------------------------------


modifier_wave_6_assassin = class({})

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("crit_chance")*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if self:GetParent():PassivesDisabled() then
			return 0.0
		end

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if self.pseudo:Trigger() then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				EmitSoundOn( "DOTA_Item.Daedelus.Crit", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_wave_6_assassin:GetModifierEvasion_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.evasion
end