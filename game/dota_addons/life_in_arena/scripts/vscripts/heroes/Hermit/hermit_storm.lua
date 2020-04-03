hermit_storm = class({})
LinkLuaModifier("modifier_hermit_storm_channel","heroes/Hermit/modifier_hermit_storm_channel.lua",LUA_MODIFIER_MOTION_NONE)

-- function hermit_storm:GetManaCost(iLevel)
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
-- 	end

-- 	return self.BaseClass.GetManaCost( self, iLevel )  
-- end

-- function hermit_storm:GetAOERadius()
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetSpecialValueFor( "radius_scepter" )
-- 	end

-- 	return self:GetSpecialValueFor( "radius" )
-- end

function hermit_storm:GetChannelTime()
	self.channel_time = self:GetSpecialValueFor( "duration" )

	return self.channel_time
end

-- function hermit_storm:OnAbilityPhaseStart()
-- 	EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Start", self:GetCaster() )
-- 	return true	
-- end

function hermit_storm:OnSpellStart()
	self.target_point = self:GetCursorPosition()
	self.caster = self:GetCaster()

	self.wave_damage = self:GetSpecialValueFor( "wave_damage" )
	self.damage_radius = self:GetSpecialValueFor( "damage_radius" )
	self.channel_modifier = self.caster:AddNewModifier(self:GetCaster(), self, "modifier_hermit_storm_channel", {duration = self.channel_time})	

	if self.caster:HasScepter() then
		self.hits_for_elemental = self:GetSpecialValueFor( "hits_for_elemental" )
		self.hits_counter = 0
	end
end

function hermit_storm:OnChannelFinish(bInterrupted)
	self.channel_modifier:Destroy()
end

function hermit_storm:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil  then
		
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												vLocation, 
												nil, self.damage_radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
												FIND_ANY_ORDER, 
												false)

		for k,v in pairs (targets) do
			local damage = {
				victim = v,
				attacker = self.caster,
				damage = self.wave_damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self
			}

			ApplyDamage( damage )
		end 

		local water_elemental_ability = self.caster:FindAbilityByName("hermit_summon_water_elemental")
		if self.caster:HasScepter() and water_elemental_ability and water_elemental_ability:GetLevel() > 0 then
			self.hits_counter = self.hits_counter + 1
			if self.hits_counter == self.hits_for_elemental then
				local elemental_lifetime = water_elemental_ability:GetSpecialValueFor("duration")
				local elemental_name = "npc_water_elemental_" .. (water_elemental_ability:GetLevel() + 1)
				local creature = CreateUnitByName(elemental_name, vLocation, false, self.caster, self.caster, self.caster:GetTeam())
				if elemental_name == "npc_water_elemental_4" then
					creature:SetRenderColor(255,0,0)
				end
				creature:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
				creature:AddNewModifier(self.caster, nil, "modifier_kill", { duration = elemental_lifetime })
				creature:AddNewModifier(self.caster, nil, "modifier_phased", { duration = 0.03 })
				ResolveNPCPositions(creature:GetAbsOrigin(),65)
				self.hits_counter = 0
			end
		end
	end

	return true
end