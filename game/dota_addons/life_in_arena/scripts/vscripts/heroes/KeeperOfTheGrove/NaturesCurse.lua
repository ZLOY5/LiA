function NaturesCurse(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("hero_duration", ability:GetLevel() - 1)

	for _,v in pairs(targets) do
		if v:IsHero() then 
			if v:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration_hero})
			end
			ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse", {duration = duration_hero})
		else 
			if v:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration})
			end
			ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse", {duration = duration})
		end
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_POINT, v)
		ParticleManager:SetParticleControlEnt(particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
	end
end

function Disarm(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("hero_duration", ability:GetLevel() - 1)

	if event.target:IsHero() then 
		ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration_hero})
	else ability:ApplyDataDrivenModifier(caster, event.target, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration})
	end
end
