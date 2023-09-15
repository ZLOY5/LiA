function modifier_item_ferus_shield_datadriven_on_attack_landed(keys)
	if --[[keys.target:GetInvulnCount() == nil and]] keys.target:GetTeamNumber() ~= keys.caster:GetTeamNumber() then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_ferus_shield_datadriven_lifesteal", {duration = 0.03})
	end
end

function PanicAttacked(keys) 
	local unit = keys.target 
	if unit:IsIdle() then 
		local point = unit:GetAbsOrigin()-keys.attacker:GetAbsOrigin()
		--point = point * 200 
		unit:MoveToPosition(point)
	end
end