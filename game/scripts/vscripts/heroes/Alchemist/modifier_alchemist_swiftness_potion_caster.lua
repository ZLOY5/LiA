modifier_alchemist_swiftness_potion_caster = class({})

function modifier_alchemist_swiftness_potion_caster:IsHidden()
	return true
end

function modifier_alchemist_swiftness_potion_caster:IsPurgable()
	return false
end

function modifier_alchemist_swiftness_potion_caster:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.unit = self:GetParent()
		self:StartIntervalThink( 0.03 )
		self.target = self.ability.vTargetPosition
		self.distance_per_tick = kv.distance_per_tick
		self.duration = kv.duration
		self.hit_width = self:GetAbility():GetSpecialValueFor("hit_width")
		self.enemy_knockback_distance = self:GetAbility():GetSpecialValueFor("enemy_knockback_distance")
		self.enemy_knockback_speed = self:GetAbility():GetSpecialValueFor("enemy_knockback_speed")
		self.enemy_knockback_duration = self.enemy_knockback_distance / self.enemy_knockback_speed
		self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
		self.buff_duration = self:GetAbility():GetSpecialValueFor("duration")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.old_position = self.unit:GetAbsOrigin()
		self.older_position = self.old_position
		self.bCanFindPath = GridNav:CanFindPath(self.old_position, self.target)
		self.hSwiftnessPotionDummy = CreateUnitByName("dummy_unit_phase_hero", self.old_position, false, self.caster, self.caster, self.caster:GetTeam())
	end
end

function modifier_alchemist_swiftness_potion_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
 
	return funcs
end

function modifier_alchemist_swiftness_potion_caster:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_alchemist_swiftness_potion_caster:GetOverrideAnimationRate()
	return 1.5
end

function modifier_alchemist_swiftness_potion_caster:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_swiftness_potion_caster:HeroEffectPriority()
	return 10
end

function modifier_alchemist_swiftness_potion_caster:OnIntervalThink()
	if IsServer() then
		local position = self.unit:GetAbsOrigin()
		local distance = (position - self.target):Length2D()
		local direction = (self.target - position):Normalized()
		local delta = (distance * 1.0 / self.duration) * 1.0 / self.distance_per_tick
		local next_position = position + direction * self.distance_per_tick

		if GridNav:IsBlocked(next_position) or not GridNav:IsTraversable(next_position) then
			self.unit:SetAbsOrigin(self.older_position)
			self.hSwiftnessPotionDummy:SetAbsOrigin(self.older_position)
	    	self:Destroy()
		else
			self.older_position = self.old_position
			self.old_position = self.unit:GetAbsOrigin()
		    self.unit:SetAbsOrigin(next_position)
		   	self.hSwiftnessPotionDummy:SetAbsOrigin(next_position)
		end

		self.caster_position = self.caster:GetAbsOrigin()

		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.caster_position,
										nil,
										self.hit_width,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

		for _,v in pairs(targets) do
			if not v:FindModifierByNameAndCaster("modifier_alchemist_swiftness_potion_enemy", self.caster) then
				local damage = {
					victim = v,
					attacker = self.caster,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				}

				ApplyDamage( damage )
				local kv =
				{
					center_x = self.caster_position.x,
					center_y = self.caster_position.y,
					center_z = self.caster_position.z,
					should_stun = false, 
					duration = self.enemy_knockback_duration,
					knockback_distance = self.enemy_knockback_distance,
				}
				v:AddNewModifier( self:GetCaster(), self.ability, "modifier_alchemist_swiftness_potion_enemy", kv )
			end
		end
	end
end

function modifier_alchemist_swiftness_potion_caster:OnDestroy()
	if IsServer() then
		local position = self.unit:GetAbsOrigin()
		-- for x = -30, 30 do
		-- 	for y = -30, 30 do
		-- 		local position_check = Vector(position.x + x, position.y + y, position.z)
		-- 		print(position_check)
		-- 		print(GridNav:IsBlocked(position_check))
		-- 		print(GridNav:IsTraversable(position_check))
		-- 	end
		-- end
		-- local decorations = FindUnitsInRadius(self.caster:GetTeamNumber(),
		-- 								self.caster_position,
		-- 								nil,
		-- 								32,
		-- 								DOTA_UNIT_TARGET_TEAM_BOTH, 
		-- 								DOTA_UNIT_TARGET_BUILDING, 
		-- 								DOTA_UNIT_TARGET_FLAG_NONE, 
		-- 								FIND_ANY_ORDER, 
		-- 								false)

		-- for i = 1, #decorations do
		-- 	print(decorations[i]:GetUnitName())
		-- 	print(decorations[i]:GetHullRadius())
		-- end
		-- self.unit:SetAbsOrigin(Vector(position.x, position.y, GetGroundHeight(position,nil)))
		-- self.unit:AddNewModifier(self.caster, self.ability, "modifier_phased", { duration = 3.3 })
		-- ResolveNPCPositions(position,65)
		-- FindClearSpaceForUnit(self.unit, position, true)

		self.hSwiftnessPotionDummy:AddNewModifier(self.caster, self.ability, "modifier_phased", { duration = 0.03 })

		Timers:CreateTimer({
            useGameTime = false,
            endTime = 0.04,
            callback = function()
				self.unit:SetAbsOrigin(self.hSwiftnessPotionDummy:GetAbsOrigin())
            end
          })

		--self.unit:AddNewModifier(self.caster, self.ability, "modifier_phased", { duration = 0.03 })
		self.hSwiftnessPotionDummy:ForceKill(false)
		self.unit:AddNewModifier( self.unit, self.ability, "modifier_alchemist_swiftness_potion_buff", {duration = self.buff_duration} )

		local hSideEffectAbility = self.caster:FindAbilityByName("alchemist_side_effect")
		if hSideEffectAbility and hSideEffectAbility:GetLevel() > 0 then
			if self.caster:HasScepter() then self.iPotionCount = 2 else self.iPotionCount = 1 end
			self.caster:FindModifierByNameAndCaster("modifier_alchemist_side_effect", self.caster):IncrementPotionCount(self.iPotionCount)
		end
	end
end

function modifier_alchemist_swiftness_potion_caster:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end