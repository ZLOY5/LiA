modifier_naga_siren_art_of_battle = class({})

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.crit_chance*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:OnRefresh( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.crit_chance*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if self:GetParent():PassivesDisabled() then
			return 0.0
		end

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if self.pseudo:Trigger() then 
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_naga_siren_art_of_battle:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

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

function modifier_naga_siren_art_of_battle:GetModifierEvasion_Constant( params )
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.evasion
end