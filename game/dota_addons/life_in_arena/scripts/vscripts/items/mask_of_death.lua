function modifier_item_mask_of_death_on_orb_impact(keys)
	if --[[keys.target:GetInvulnCount() == nil and]] keys.target:GetTeamNumber() ~= keys.caster:GetTeamNumber() and not keys.caster:HasAbility("vampire_lifesteal") then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_mask_of_death_lifesteal", {duration = 0.03})
	end
end