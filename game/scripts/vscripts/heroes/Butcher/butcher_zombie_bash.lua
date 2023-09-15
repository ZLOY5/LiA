
butcher_zombie_bash = class({})
LinkLuaModifier( "modifier_butcher_zombie_bash", "heroes/Butcher/butcher_zombie_bash.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function butcher_zombie_bash:GetIntrinsicModifierName()
	return "modifier_butcher_zombie_bash"
end

--------------------------------------------------------------------------------


modifier_butcher_zombie_bash = class({})

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bash:OnCreated( kv )
	self.bash_chance = self:GetAbility():GetSpecialValueFor( "bash_chance" )
	self.bash_damage = self:GetAbility():GetSpecialValueFor( "bash_damage" )
	self.bash_duration = self:GetAbility():GetSpecialValueFor( "bash_duration" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("bash_chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bash:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_butcher_zombie_bash:OnAttackLanded( params )
	if IsServer() then
		if params.attacker:PassivesDisabled() or params.attacker:IsIllusion() then
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
