LinkLuaModifier("modifier_archmage_shooting_star_cooldown", "heroes/Archmage/modifier_archmage_shooting_star_cooldown.lua",LUA_MODIFIER_MOTION_NONE)

function ShootingStar(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local initial_damage = ability:GetSpecialValueFor("initial_damage")
	local damage_per_charge = ability:GetSpecialValueFor("damage_per_charge")
	local manacost_per_charge = ability:GetSpecialValueFor("manacost_per_charge")
	local charge_duration = ability:GetSpecialValueFor("charge_duration")
	local charge_limit = ability:GetSpecialValueFor("charge_limit")
	shootingStarStacks = 0

	ApplyDamage({victim = target, attacker = caster, damage = initial_damage + shootingStarStacks*damage_per_charge, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_archmage_shooting_star_stacks",{duration = charge_duration})


end

function OnCreated(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target

	shootingStarStacks = shootingStarStacks + 1

	caster:AddNewModifier(caster,ability,"modifier_archmage_shooting_star_cooldown",nil)


end

function OnDestroy(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target

	shootingStarStacks = shootingStarStacks - 1
	
end