function HeavenWrath(event)
	local caster = event.caster
	local possible_targets = event.target_entities
	local ability = event.ability
	local target

	while #possible_targets ~= 0 do
		local key = RandomInt(1, #possible_targets)
		local possible_target = possible_targets[key]
		if possible_target ~= ability.lastTarget then
			if possible_target:IsRealHero() or string.find(possible_target:GetUnitName(),"megaboss") then
				if possible_target:GetHealthPercent() > event.heaven_wrath_min_health_heroes then
					target = possible_target
					break
				end
			else
				target = possible_target
				break
			end
		end
		table.remove(possible_targets,key)
	end

	ability.lastTarget = target

	if target then
		ApplyDamage({victim = target, attacker = caster, damage = event.heaven_wrath_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}) 		
		local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, target)
    	local loc = target:GetAbsOrigin()
    	ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
    	ParticleManager:SetParticleControl(lightning, 1, loc)
    	ParticleManager:SetParticleControl(lightning, 2, loc)
    	EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)	
	end
end