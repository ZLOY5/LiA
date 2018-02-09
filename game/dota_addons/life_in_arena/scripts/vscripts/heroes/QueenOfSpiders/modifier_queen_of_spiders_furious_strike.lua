modifier_queen_of_spiders_furious_strike = class({})

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_furious_strike:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
			local hAttacker = params.attacker
			self.full_damage_radius = self:GetAbility():GetSpecialValueFor( "full_damage_radius" )
			self.half_damage_radius = self:GetAbility():GetSpecialValueFor( "half_damage_radius" )
			self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
			if hTarget ~= nil and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
				if self.pseudo:Trigger() then
				
					local full_damage_targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
											hTarget:GetAbsOrigin(), 
											nil, self.full_damage_radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

					local half_damage_targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
											hTarget:GetAbsOrigin(), 
											nil, self.half_damage_radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

					for _,s in pairs (full_damage_targets) do
						print(self.damage)
						ApplyDamage({ victim = s, attacker = params.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
					end

					for _,v in pairs (half_damage_targets) do
						local bDealDamage = true
						for _,s in pairs (full_damage_targets) do
							if s == v then
								bDealDamage = false
								break
							end
						end
						if bDealDamage == true then
							print(self.damage/2)
							ApplyDamage({ victim = v, attacker = params.attacker, damage = self.damage / 2, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })	
						end
					end 
				end
			end
		end
	end

	return 0.0
end