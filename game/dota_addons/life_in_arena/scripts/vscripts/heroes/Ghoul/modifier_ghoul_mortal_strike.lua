
modifier_ghoul_mortal_strike = class({})

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.crit_chance*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:OnRefresh( kv )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghoul_mortal_strike:GetModifierPreAttack_CriticalStrike( params )
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

function modifier_ghoul_mortal_strike:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
				ParticleManager:SetParticleControl(nFXIndex,0,hTarget:GetOrigin())
				ParticleManager:SetParticleControl(nFXIndex,1,hTarget:GetOrigin())
				EmitSoundOn( "Hero_PhantomAssassin.CoupDeGrace", self:GetParent() )   
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end
