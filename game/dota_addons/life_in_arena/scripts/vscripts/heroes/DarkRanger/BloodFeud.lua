function OnDeath(event)
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	local hero_kill_duration = ability:GetSpecialValueFor("hero_kill_duration")
	local megaboss_duration_percentage = ability:GetSpecialValueFor("megaboss_duration_percentage") * 0.01

	if target:IsHero() then
		if string.find(attacker:GetUnitName(),"megaboss") or attacker:IsHero() then
			attacker:ApplyDataDrivenModifier(caster,attacker,"modifier_dark_ranger_blood_feud_blood_enemy_hero_kill",{duration = hero_kill_duration * megaboss_duration_percentage})
		else
			attacker:ApplyDataDrivenModifier(caster,attacker,"modifier_dark_ranger_blood_feud_blood_enemy_hero_kill",{duration = hero_kill_duration})
		end
	else	
		if string.find(attacker:GetUnitName(),"megaboss") or attacker:IsHero() then
			attacker:ApplyDataDrivenModifier(caster,attacker,"modifier_dark_ranger_blood_feud_blood_enemy_creep_kill",{duration = duration * megaboss_duration_percentage})
		else
			attacker:ApplyDataDrivenModifier(caster,attacker,"modifier_dark_ranger_blood_feud_blood_enemy_creep_kill",{duration = duration})
		end
	end

end

function CreepKillerAttacked(event)
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("bonus_attack_speed_duration")


	if caster.target.isBloodEnemy == nil then
		caster.target.isBloodEnemy = true
	end

	if caster.target.isBloodEnemy == true then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_dark_ranger_blood_feud_attack_speed",{duration = duration})
	end
end

function HeroKillerAttacked(event)
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("bonus_attack_speed_hero_kill_duration")

	if caster.target.isBloodEnemy == nil then
		caster.target.isBloodEnemy = true
	end

	if caster.target.isBloodEnemy == true then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_dark_ranger_blood_feud_attack_speed",{duration = duration})
	end
end