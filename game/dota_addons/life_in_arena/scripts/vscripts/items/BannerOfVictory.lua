function modifier_item_banner_of_victory_datadriven_on_attack_landed(keys)
	if --[[keys.target:GetInvulnCount() == nil and]] not keys.target:IsMechanical() and keys.target:GetTeamNumber() ~= keys.caster:GetTeamNumber() then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_banner_of_victory_datadriven_lifesteal", {duration = 0.03})
	end
end