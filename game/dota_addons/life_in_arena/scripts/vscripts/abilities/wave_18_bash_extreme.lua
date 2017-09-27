
wave_18_bash_extreme = class({})
LinkLuaModifier( "modifier_wave_18_bash_extreme", "abilities/wave_18_bash_extreme.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_18_bash_extreme:GetIntrinsicModifierName()
	return "modifier_wave_18_bash_extreme"
end

--------------------------------------------------------------------------------


modifier_wave_18_bash_extreme = class({})

--------------------------------------------------------------------------------

function modifier_wave_18_bash_extreme:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_18_bash_extreme:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_18_bash_extreme:OnCreated( kv )
	self.bash_chance = self:GetAbility():GetSpecialValueFor( "bash_chance" )
	self.bash_damage = self:GetAbility():GetSpecialValueFor( "bash_damage" )
	self.bash_duration = self:GetAbility():GetSpecialValueFor( "bash_duration" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("bash_chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_wave_18_bash_extreme:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_18_bash_extreme:OnAttackLanded( params )
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
