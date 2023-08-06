function LifeDrainFirstInstance(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local damage = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1)
	local blood_particle = "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"

	--print(caster.thirst_points or 0)
	life_drain_damage = damage + (caster.thirst_points or 0)*2

	if caster.thirst_points then
		caster.thirst_points = 0
	end
	local modifier = caster:FindModifierByName("modifier_vampire_lifesteal")
	if modifier then
		modifier:SetStackCount(0)
	end
	local sound_count = 0
	for _,v in pairs(targets) do
		local particle = ParticleManager:CreateParticle(blood_particle, PATTACH_POINT_FOLLOW, target) 
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
		ApplyDamage({ victim = v, attacker = caster, damage = life_drain_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		caster:Heal(life_drain_damage, caster)	
		sound_count = sound_count + 1
	end
	if sound_count > 0 then
		caster:EmitSound("Hero_Bloodseeker.Rupture")
	end
end

function LifeDrain(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local blood_particle = "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"
	local sound_count = 0
	for _,v in pairs(targets) do
		local particle = ParticleManager:CreateParticle(blood_particle, PATTACH_POINT_FOLLOW, target) 
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
		ApplyDamage({ victim = v, attacker = caster, damage = life_drain_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		caster:Heal(life_drain_damage, caster)	
		sound_count = sound_count + 1
	end
	if sound_count > 0 then
		caster:EmitSound("Hero_Bloodseeker.Rupture")
	end
end