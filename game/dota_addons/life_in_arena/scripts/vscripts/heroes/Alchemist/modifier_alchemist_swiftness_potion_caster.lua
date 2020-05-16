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

function modifier_alchemist_swiftness_potion_caster:OnIntervalThink()
	if IsServer() then
		local position = self.unit:GetAbsOrigin()
		local distance = (self.unit:GetAbsOrigin() - self.target):Length2D()
		local direction = (self.target - self.unit:GetAbsOrigin()):Normalized()
		local delta = (distance * 1.0 / self.duration) * 1.0 / self.distance_per_tick
		local next_position = position + direction * delta

		if GridNav:IsBlocked(next_position) or not GridNav:IsTraversable(next_position) then
			if not self.bCanFindPath then
				self.unit:SetAbsOrigin(self.older_position)
		    	self:Destroy()
		    else
		    	self.older_position = self.old_position
				self.old_position = self.unit:GetAbsOrigin()
		    	self.unit:SetAbsOrigin(next_position)
		    end
		else
			self.older_position = self.old_position
			self.old_position = self.unit:GetAbsOrigin()
		    self.unit:SetAbsOrigin(next_position)
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
				v:AddNewModifier( self:GetCaster(), self.ability, "modifier_stunned", {duration = self.stun_duration} )
			end
		end
	end
end

function modifier_alchemist_swiftness_potion_caster:OnDestroy()
	if IsServer() then
		print(GridNav:IsBlocked(self.unit:GetAbsOrigin()))
		FindClearSpaceForUnit(self.unit, self.unit:GetAbsOrigin(), true)
		self.unit:AddNewModifier(self.caster, self.ability, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(self.unit:GetAbsOrigin(),65)
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