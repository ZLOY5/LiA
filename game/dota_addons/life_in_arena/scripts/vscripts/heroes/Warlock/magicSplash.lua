function MagicSplash(event)
	--[[for k,v in pairs(event) do
		print(k,v)
	end]]

	local eventAbility = event.event_ability

	if eventAbility:IsItem() then 
		return 
	end

	local caster = event.caster
	local ability = event.ability

	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")

	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		ParticleManager:CreateParticle("particles/custom/warlock/keeper_mana_leak.vpcf",PATTACH_ABSORIGIN,unit)
	end
end

--[[[   VScript ]: unit	table: 0x00231508
[   VScript ]: caster	table: 0x00231508
[   VScript ]: caster_entindex	808
[   VScript ]: ScriptFile	heroes\Warlock\MagicSplash.lua
[   VScript ]: event_ability	table: 0x0021be10
[   VScript ]: Function	MagicSplash
[   VScript ]: ability	table: 0x00271b80]]