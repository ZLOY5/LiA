modifier_frost_lord_freezing = class({})

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:OnCreated( kv )
	self.freezing_chance = self:GetAbility():GetSpecialValueFor( "freezing_chance" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.freezing_chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:OnRefresh( kv )
	self.freezing_chance = self:GetAbility():GetSpecialValueFor( "freezing_chance" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.freezing_chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.target then  
			if self:GetParent():PassivesDisabled() then 
				return
			end

			if ( params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber() ) and not params.attacker:IsMagicImmune() and not params.attacker:IsInvulnerable() then
				if self.pseudo:Trigger() then
					ApplyDamage({ victim = params.attacker, attacker = params.target, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
					params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_frost_lord_freezing_debuff", {duration = self.stun_duration})
					EmitSoundOn( "hero_Crystal.frostbite", params.attacker )  
				end	
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

