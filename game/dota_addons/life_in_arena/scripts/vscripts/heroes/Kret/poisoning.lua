--[[

]]



function SetAdsorbFromKret( keys )
	local attacker_loc = keys.attacker
	local caster = keys.caster
	local adsorbVal = keys.adsorbVal
	--
	ApplyDamage(
	{
		victim = attacker_loc,
		attacker = caster,
		damage = adsorbVal,
		damage_type = DAMAGE_TYPE_PHYSICAL
	})
	--
	attacker_loc:ReduceMana(adsorbVal)
end


