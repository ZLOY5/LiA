function modifier_vampire_lifesteal_lifesteal(keys)
	if --[[keys.target:GetInvulnCount() == nil and]] not keys.target:IsMechanical() and keys.target:GetTeamNumber() ~= keys.caster:GetTeamNumber() then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_vampire_lifesteal_lifesteal", {duration = 0.03})
	end
end

function thirst_points(event)
	if event.ability:GetLevel() == 1 then
		thirst_points = 0
		event.caster:SetModifierStackCount("modifier_vampire_lifesteal", event.caster, thirst_points)
	end
end

function ThirstPointsGain(event)
	thirst_points_max = event.ability:GetLevelSpecialValueFor("thirst_points_max", event.ability:GetLevel() - 1)
	if thirst_points < thirst_points_max then
		thirst_points = thirst_points + 1
		event.caster:SetModifierStackCount("modifier_vampire_lifesteal", event.caster, thirst_points)
	end
end