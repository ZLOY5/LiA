function damageTo(event)
local caster = event.caster
--local target = event.target
local attacker = event.attacker
local ability = event.ability
--
local damage_per_int = ability:GetSpecialValueFor("damage_per_int")
local radius_dop_dmg = ability:GetSpecialValueFor("radius_dop_dmg")
local intcast = caster:GetBaseIntellect()
--
local damageType = DAMAGE_TYPE_MAGICAL
local damage = damage_per_int * intcast
--
--print("		caster = ", caster )
--print("		target = ", target )
--print("		unit = ", event.unit )
--print("		attacker = ", attacker )

local damage_table = { 
  attacker = caster,
	damage_type = damageType, 
	damage = damage,
	ability = ability,
	victim = attacker,
}
	

ApplyDamage(damage_table)

attacker:EmitSound("Hero_Disruptor.ThunderStrike.Target")

	local targets = FindUnitsInRadius(caster:GetTeam() ,attacker:GetAbsOrigin(), nil, radius_dop_dmg, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage/2, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
	end

end 
