lord_of_lightning_chain_lightning = class({})

function lord_of_lightning_chain_lightning:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function lord_of_lightning_chain_lightning:GetCooldown(iLevel)
	--print("Level",iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function lord_of_lightning_chain_lightning:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	
	local damage = self:GetSpecialValueFor(caster:HasScepter() and "lightning_damage_scepter" or "lightning_damage")
	local bounces = self:GetSpecialValueFor(caster:HasScepter() and "lightning_bounces_scepter" or "lightning_bounces")
	local decay = self:GetSpecialValueFor(caster:HasScepter() and "lightning_decay_scepter" or "lightning_decay") * 0.01
	
	local bounce_range = self:GetSpecialValueFor("bounce_range")
	local time_between_bounces = self:GetSpecialValueFor("time_between_bounces")

	local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
	--local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf", PATTACH_WORLDORIGIN, hero)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))	
	--ParticleManager:SetParticleControlEnt(lightningBolt, 1, target, 1, "attach_hitloc", target:GetAbsOrigin(), true)

	EmitSoundOn("Hero_Zuus.ArcLightning.Cast", caster)
	EmitSoundOn("Hero_Dazzle.Shadow_Wave", target)	

	if target:TriggerSpellAbsorb(self) then
		return 
	end

	ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
	--PopupDamage(target,math.floor(damage))

	-- Every target struck by the chain is added to a list of targets struck, And set a boolean inside its index to be sure we don't hit it twice.
	local targetsStruck = {}
	target.struckByChain = true
	table.insert(targetsStruck,target)

	local dummy = nil
	local units = nil

	Timers:CreateTimer(DoUniqueString("ChainLightning"), {
		endTime = time_between_bounces,
		callback = function()
	
			-- unit selection and counting
			units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetOrigin(), target, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, 
						DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)

			-- particle and dummy to start the chain
			targetVec = target:GetAbsOrigin()
			targetVec.z = target:GetAbsOrigin().z + target:GetBoundingMaxs().z
			if dummy ~= nil then
				dummy:RemoveSelf()
			end
			dummy = CreateUnitByName("dummy_unit", targetVec, false, hero, hero, hero:GetTeam())

			-- Track the possible targets to bounce from the units in radius
			local possibleTargetsBounce = {}
			for _,v in pairs(units) do
				if not v.struckByChain then
					table.insert(possibleTargetsBounce,v)
				end
			end

			-- Select nearest unit
			local newTarget 
			local distance = bounce_range
			local newTargetVec
			for _,v in pairs(possibleTargetsBounce) do
				newTargetVec = v:GetAbsOrigin()
				--print(v,DistanceBetweenVectors(targetVec,newTargetVec)) 
				if v ~= target then
					if DistanceBetweenPoints(targetVec,newTargetVec) < distance then
						newTarget = v
						distance = DistanceBetweenPoints(targetVec,newTargetVec)
					end
				end
			end
			target = newTarget

			if target then
				target.struckByChain = true
				table.insert(targetsStruck,target)		
			else
				-- There's no more targets left to bounce, clear the struck table and end
				for _,v in pairs(targetsStruck) do
				    v.struckByChain = false
				    v = nil
				end
			    --print("End Chain, no more targets")
				return	
			end

			local lightningChain = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, dummy)
			--local lightningChain = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf", PATTACH_WORLDORIGIN, dummy)
			ParticleManager:SetParticleControl(lightningChain,0,Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,dummy:GetAbsOrigin().z + dummy:GetBoundingMaxs().z ))	
			
			-- damage and decay
			damage = damage - (damage*decay)
			ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
			--PopupDamage(target,math.floor(damage))
			--print("Bounce "..bounces.." Hit Unit "..target:GetEntityIndex().. " for "..damage.." damage")

			-- play the sound
			EmitSoundOn("Hero_Zuus.ArcLightning.Target",target)

			-- make the particle shoot to the target
			ParticleManager:SetParticleControl(lightningChain,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	
			-- decrement remaining spell bounces
			bounces = bounces - 1

			-- fire the timer again if spell bounces remain
			if bounces > 0 then
				return time_between_bounces
			else
				for _,v in pairs(targetsStruck) do
				   	v.struckByChain = false
				   	v = nil
				end
				--print("End Chain, no more bounces")
			end
		end
	})

end