function Roots(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("root_duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("root_hero_duration", ability:GetLevel() - 1)

	for _,v in pairs(targets) do
		if v:IsHero() then 
			ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_roots", {duration = duration_hero})
			ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_roots_damage", {duration = duration_hero - 1})
		else ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_roots", {duration = duration})
			 ability:ApplyDataDrivenModifier(caster, v, "modifier_keeper_of_the_grove_roots_damage", {duration = duration - 1})
		end
	end
end