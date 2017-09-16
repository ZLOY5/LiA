
megaboss_5_bash = class({})
LinkLuaModifier( "modifier_megaboss_5_bash", "abilities/megaboss_5_bash.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function megaboss_5_bash:GetIntrinsicModifierName()
	return "modifier_megaboss_5_bash"
end

--------------------------------------------------------------------------------


modifier_megaboss_5_bash = class({})

--------------------------------------------------------------------------------

function modifier_megaboss_5_bash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_megaboss_5_bash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_megaboss_5_bash:OnCreated( kv )
	self.bash_chance = self:GetAbility():GetSpecialValueFor( "bash_chance" )
	self.bash_damage = self:GetAbility():GetSpecialValueFor( "bash_damage" )
	self.bash_duration = self:GetAbility():GetSpecialValueFor( "bash_duration" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("bash_chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_megaboss_5_bash:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_megaboss_5_bash:OnAttackLanded( params )
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return 
		end

		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.pseudo:Trigger() then
				local damageTable = {
						 	victim = params.target, 
						 	attacker = params.attacker, 
						 	damage = self:GetAbility():GetSpecialValueFor("bash_damage"), 
						 	damage_type = DAMAGE_TYPE_MAGICAL,
						 	ability = self:GetAbility()
						}

				params.target:AddNewModifier(params.attacker,self:GetAbility(),"modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("bash_duration")})
				ApplyDamage(damageTable)
				EmitSoundOn( "Roshan.Bash", params.attacker )

			end
		end
	end

end

--------------------------------------------------------------------------------
