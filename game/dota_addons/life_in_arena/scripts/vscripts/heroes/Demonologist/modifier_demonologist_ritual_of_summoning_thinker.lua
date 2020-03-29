modifier_demonologist_ritual_of_summoning_thinker = class({})

--------------------------------------------------------------------------------

function modifier_demonologist_ritual_of_summoning_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_demonologist_ritual_of_summoning_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_demonologist_ritual_of_summoning_thinker:OnCreated( kv )
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local target = ability.target
		self.radius = self:GetAbility():GetSpecialValueFor("spawn_radius")
		self.ritualSpawnParticle = ParticleManager:CreateParticle("particles/custom/demonologist/lia_demonog_render.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl( self.ritualSpawnParticle, 0, target )
		ParticleManager:SetParticleControl( self.ritualSpawnParticle, 1, Vector( self.radius, 1, 1 ) )
		ParticleManager:SetParticleControl( self.ritualSpawnParticle, 2, target )
		self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")
	end
end

--------------------------------------------------------------------------------

function modifier_demonologist_ritual_of_summoning_thinker:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local target = ability.target
		local default_creeps = ability:GetSpecialValueFor("unit_count")
		local additional_creeps = caster:GetIntellect() / ability:GetSpecialValueFor("intelligence_for_unit")
		local boss_count = 0

		if caster:HasScepter() then
			boss_count = ability:GetSpecialValueFor( "boss_count_scepter" )
		else
			boss_count = ability:GetSpecialValueFor( "boss_count" )
		end

		self.demonologistUltimateCreepCount = math.floor(default_creeps + additional_creeps)
		self.demonologistUltimateBossCount = boss_count

		if Survival.nRoundNum % 5 == 0 then
			self.demonologistUltimateCreepCount = math.floor(self.demonologistUltimateCreepCount/2)
		end
		if Survival.IsDuelOccured then
			self.demonologistUltimateCreepCount = math.floor(self.demonologistUltimateCreepCount/2)
			self.demonologistUltimateBossCount = 0
		end


		local creep_name
		local boss_name

		if ((Survival.nRoundNum + 1) % 5 == 0) and (Survival.nRoundNum ~= 19) then
			creep_name = tostring(Survival.nRoundNum + 2).."_wave_creep"
			boss_name = tostring(Survival.nRoundNum + 2).."_wave_boss"
		elseif Survival.nRoundNum == 19 or Survival.nRoundNum == 20 then
			creep_name = "19_wave_creep"
			boss_name = "19_wave_boss"
		else
			creep_name = tostring(Survival.nRoundNum + 1).."_wave_creep"
			boss_name = tostring(Survival.nRoundNum + 1).."_wave_boss"
		end
		ParticleManager:DestroyParticle(self.ritualSpawnParticle,true)
		StopSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetParent())
		self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")

		if self.demonologistUltimateBossCount > 0 then
		    for i=1,self.demonologistUltimateBossCount do
		        local demonologistBoss = CreateUnitByName(boss_name, target, true, caster, caster, caster:GetTeam())
	        	demonologistBoss:AddNewModifier(caster, ability, "modifier_demonologist_ritual_of_summoning_creep_debuff", nil)
		        for k=0,15 do
					local abilityToRemove = demonologistBoss:GetAbilityByIndex(k)
					if abilityToRemove then
						if not abilityToRemove:IsPassive() then
							demonologistBoss:RemoveAbility(abilityToRemove:GetAbilityName())
						end
					end
				end
		        demonologistBoss.demonologistRitualCreep = true
				demonologistBoss:SetControllableByPlayer(caster:GetPlayerID(), true)
				ResolveNPCPositions(demonologistBoss:GetAbsOrigin(),100)
				demonologistBoss:SetAcquisitionRange(500)
		    end
		end

    	local points = self.demonologistUltimateCreepCount
		
		for i=1,points do
	        local position = self:GetPositionOnCircle(target,Vector(1,0,0),self.radius,i,points)
	        local demonologistCreep = CreateUnitByName(creep_name, target, true, caster, caster, caster:GetTeam())
	        demonologistCreep:AddNewModifier(caster, ability, "modifier_demonologist_ritual_of_summoning_creep_debuff", nil)
	        for k=0,15 do
				local abilityToRemove = demonologistCreep:GetAbilityByIndex(k)
				if abilityToRemove then
					if not abilityToRemove:IsPassive() then
						demonologistCreep:RemoveAbility(abilityToRemove:GetAbilityName())
					end
				end
			end
	        demonologistCreep.demonologistRitualCreep = true
			demonologistCreep:SetControllableByPlayer(caster:GetPlayerID(), true)
			ResolveNPCPositions(demonologistCreep:GetAbsOrigin(),100)
			demonologistCreep:SetAcquisitionRange(500)
	    end

	end
end

--------------------------------------------------------------------------------

function modifier_demonologist_ritual_of_summoning_thinker:GetPositionOnCircle(vCenter,vForward,flRadius,nPosition,nPositionCount)
	 local angle = nPosition / nPositionCount * 360
	 local QAngle = VectorToAngles(vForward)
	 QAngle.y = QAngle.y + angle
	 return RotatePosition(vCenter, QAngle, vCenter+vForward*flRadius)
end