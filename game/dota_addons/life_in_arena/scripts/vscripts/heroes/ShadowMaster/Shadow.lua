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
	local attrPerc = ability:GetLevelSpecialValueFor("shadow_attributes_perc", abiLevel-1)*0.01

	local shadow_abilities = {"shadow_return_to_owner","",""}

	if ability.shadow and IsValidEntity(ability.shadow) then
		ability.shadow:ForceKill(true)
	end

	local spawnPos = caster:GetAbsOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,90,0),caster:GetForwardVector())*125

	local shadow = CreateUnitByName("npc_dota_hero_terrorblade", spawnPos, true, caster, nil, caster:GetTeamNumber())
	shadow:SetControllableByPlayer(caster:GetPlayerID(), true)
	shadow:SetPlayerID(caster:GetPlayerID())

	shadow:SetRenderColor(20, 20, 20)
	
	shadow:SetForwardVector(caster:GetForwardVector()) 

	shadow:AddNewModifier(shadow, nil, "modifier_kill", {duration = lifetime})
	
	shadow:RemoveAbility("shadow_master_shadow")
	shadow:RemoveAbility("shadow_master_steal_shadow")
	shadow:RemoveAbility("shadow_master_art_of_shadows")
	shadow:RemoveAbility("shadow_master_sleight_of_shadows")
	shadow:RemoveAbility("attribute_bonuses")

	for i=1, abiLevel, 1 do 
		shadow:AddAbility(shadow_abilities[i])
		shadow:FindAbilityByName(shadow_abilities[i]):SetLevel(1)
	end

	shadow:SetAbilityPoints(0)

	shadow:SetBaseAgility(math.ceil(caster:GetAgility()*attrPerc))
	shadow:SetBaseStrength(math.ceil(caster:GetStrength()*attrPerc))
	shadow:SetBaseIntellect(math.ceil(caster:GetIntellect()*attrPerc))
	shadow:CalculateStatBonus()

	shadow:SetHealth(shadow:GetMaxHealth()*caster:GetHealthPercent()*0.01)

	shadow:SetHasInventory(false)

	shadow:EmitSound("Hero_Terrorblade.Reflection")

	ability:ApplyDataDrivenModifier(caster, shadow, "modifier_shadow", nil)

	shadow.owner = caster
	ability.shadow = shadow
end

function RemoveShadow(event)
	Timers:CreateTimer(3,function()
		event.unit:RemoveSelf()
	end)
end

function KillShadow(event)
	event.ability.shadow:ForceKill(true)
end