LinkLuaModifier("modifier_lia_shadow", "heroes/ShadowMaster/modifier_lia_shadow.lua",LUA_MODIFIER_MOTION_NONE)

function ShadowCast( event )

	local caster = event.caster
	local spawnPos = caster:GetAbsOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,90,0),caster:GetForwardVector())*125
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf"

	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControl(particle, 3, Vector(1,0,0))
	
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", spawnPos, true)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", spawnPos, true)

end

function SpawnShadow(event)
	local caster = event.caster
	local ability = event.ability
	local abiLevel = ability:GetLevel()

	local lifetime = ability:GetSpecialValueFor("shadow_lifetime")
	local attrPerc = ability:GetSpecialValueFor("shadow_attributes_perc")*0.01

	if ability.shadow and IsValidEntity(ability.shadow) then
		ability.shadow:ForceKill(false)
	end

	local casterForwardVec = caster:GetForwardVector()
	local spawnPos = caster:GetAbsOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,90,0),casterForwardVec)*125

	local strength = caster:GetStrength() * attrPerc
	local agility = caster:GetAgility() * attrPerc
	local intellect = caster:GetIntellect() * attrPerc

	ability.shadow = CreateShadow(caster,spawnPos,casterForwardVec,lifetime,strength,agility,intellect,abiLevel)

	local modifierAgi = caster:FindModifierByName("modifier_art_of_shadows_buff") --бафф ульты
	if modifierAgi then
		local abiAgi = modifierAgi:GetAbility()
		abiAgi:ApplyDataDrivenModifier(caster, ability.shadow, "modifier_art_of_shadows_buff", {duration = modifierAgi:GetRemainingTime()})
	end

	ability.shadow:EmitSound("Hero_Terrorblade.Reflection")

	
end

function HeroDied(event)
	if event.ability.shadow and IsValidEntity(event.ability.shadow) then
		event.ability.shadow:ForceKill(false)
	end
end

function _G.CreateShadow(caster,originVec,forwardVec,lifetime,strength,agility,intellect,lvl)
	local shadow = CreateUnitByName("shadow_master_shadow", originVec, true, caster, caster, caster:GetTeamNumber())
	shadow:SetControllableByPlayer(caster:GetPlayerID(), true)

	ResolveNPCPositions(shadow:GetAbsOrigin(),65)

	--shadow:SetRenderColor(20, 20, 20)
	
	shadow:SetForwardVector(forwardVec) 

	shadow:SetHasInventory(false)

	local healthBonus = strength * HERO_STATS_HEALTH_BONUS
    local armorBonus = agility * HERO_STATS_ARMOR_BONUS
    shadow:SetMaxHealth(shadow:GetMaxHealth()+healthBonus)
    shadow:SetHealth(shadow:GetMaxHealth())
    shadow:SetPhysicalArmorBaseValue(shadow:GetPhysicalArmorBaseValue()+armorBonus)

    for i=1,lvl do
    	local ability = shadow:GetAbilityByIndex(i-1)
    	if ability then 
    		ability:SetLevel(1)
    	end
    end
	
	shadow:AddNewModifier(caster, ability, "modifier_lia_shadow", {agility = agility, strength = strength, intellect = intellect})
	shadow:AddNewModifier(shadow, nil, "modifier_kill", {duration = lifetime})

	shadow.strength = strength
	shadow.agility = agility
	shadow.intellect = intellect

	return shadow
end