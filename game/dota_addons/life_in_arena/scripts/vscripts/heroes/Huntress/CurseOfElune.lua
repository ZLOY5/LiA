--[[

]]



function SetDamageFromHuntress( keys )
	local target = keys.target
	local damage_per_sec = keys.damage_per_sec
	local damage_proc_for_creeps = keys.damage_proc_for_creeps
	local damage_proc_for_heroes_and_mega = keys.damage_proc_for_heroes_and_mega
	local calc_damage
	local not_full_hp = target:GetMaxHealth() - target:GetHealth()
	if target:IsHero() or string.find(target:GetUnitName(),"megaboss") then
		calc_damage = not_full_hp * damage_proc_for_heroes_and_mega * 0.01 + damage_per_sec
	else
		calc_damage = not_full_hp * damage_proc_for_creeps * 0.01 + damage_per_sec
	end
	ApplyDamage(
	{
		victim = target,
		attacker = keys.caster,
		damage = calc_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability
	})
end



