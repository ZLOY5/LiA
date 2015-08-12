function Roots(event)
	local targets = event.target_entities
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor("root_duration", ability:GetLevel() - 1)
	local duration_hero = ability:GetLevelSpecialValueFor("root_hero_duration", ability:GetLevel() - 1)

	for _,target in pairs(targets) do
		if v:IsHero() then 
			caster:AddNewModifier(caster, ability, "modifier_vampire_transformation_regen", {duration = duration_hero})
			caster:AddNewModifier(caster, ability, "modifier_keeper_of_the_grove_roots_damage", {duration = duration_hero - 1})
		else caster:AddNewModifier(caster, ability, "modifier_vampire_transformation_regen", {duration = duration})
			 caster:AddNewModifier(caster, ability, "modifier_keeper_of_the_grove_roots_damage", {duration = duration - 1})
		end
	end
end