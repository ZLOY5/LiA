function NaturesCurse(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("hero_duration", ability:GetLevel() - 1)

	for _,target in pairs(targets) do
		if v:IsHero() then 
			ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse", {duration = duration_hero})
		else ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_natures_curse", {duration = duration})
		end
	end
end

function Disarm(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("hero_duration", ability:GetLevel() - 1)

	if v:IsHero() then 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration_hero})
	else ability:ApplyDataDrivenModifier(caster, target, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = duration})
	end
end
