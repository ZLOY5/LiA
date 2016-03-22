require("heroes/ShadowMaster/Shadow")

function ArtOfShadows(event)
	local caster = event.caster
	local ability = event.ability

	local shadowsMax = ability:GetSpecialValueFor("max_shadows")
	if not ability.shadowsNumber then 
		ability.shadowsNumber = 0
		ability.shadows = {}
	end 

	if (ability.shadowsNumber >= shadowsMax) or (event.target:GetTeamNumber() == caster:GetTeamNumber()) then 
		return 
	end

	local lifetime = ability:GetSpecialValueFor("shadow_lifetime")
	local attrPerc = ability:GetSpecialValueFor("shadow_attributes_perc")*0.01

	local casterForwardVec = caster:GetForwardVector()
	local spawnPos = caster:GetAbsOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,-90,0),casterForwardVec)*75

	local strength = caster:GetStrength() * attrPerc
	local agility = caster:GetAgility() * attrPerc
	local intellect = caster:GetIntellect() * attrPerc

	local shadow = CreateShadow(caster,spawnPos,casterForwardVec,lifetime,strength,agility,intellect,2)
	ability:ApplyDataDrivenModifier(caster, shadow, "modifier_art_of_shadows_shadow", nil)

	local modifierAgi = caster:FindModifierByName("modifier_art_of_shadows_buff") --бафф ульты
	if modifierAgi then
		local abiAgi = modifierAgi:GetAbility()
		abiAgi:ApplyDataDrivenModifier(caster, shadow, "modifier_art_of_shadows_buff", {duration = modifierAgi:GetRemainingTime()})
	end
	
	table.insert(ability.shadows, shadow)
	ability.shadowsNumber = ability.shadowsNumber + 1

	caster:SetModifierStackCount("modifier_art_of_shadows", caster, ability.shadowsNumber)
end

function ShadowDeath(event)
	local caster = event.caster
	local ability = event.ability

	ability.shadowsNumber = ability.shadowsNumber - 1

	for k,v in pairs(ability.shadows) do 
		if v == event.unit then 
			table.remove(ability.shadows,k)
			break
		end
	end

	caster:SetModifierStackCount("modifier_art_of_shadows", caster, ability.shadowsNumber)
end

function HeroDied(event)
	local caster = event.caster
	local ability = event.ability

	if not ability.shadowsNumber then 
		ability.shadowsNumber = 0
		ability.shadows = {}
	end 
	
	ability.shadowsNumber = 0

	for k,v in pairs(ability.shadows) do 
		v:ForceKill(false)
	end

	ability.shadows = {}
end