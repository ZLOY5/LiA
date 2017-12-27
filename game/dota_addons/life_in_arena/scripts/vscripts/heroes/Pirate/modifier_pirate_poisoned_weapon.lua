modifier_pirate_poisoned_weapon = class({})

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_pirate_poisoned_weapon:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
			local hAttacker = params.attacker
			if hTarget ~= nil and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
				local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, self.radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										0, 0, false)

				for k,v in pairs (targets) do
					v:AddNewModifier(hAttacker, self:GetAbility(), "modifier_pirate_poisoned_weapon_debuff", {duration = self.duration})

					local damage = {
							victim = v,
							attacker = hAttacker,
							damage = self.damage_per_second,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self:GetAbility()
						}

					ApplyDamage( damage )
				end 
			end
		end
	end

	return 0.0
end