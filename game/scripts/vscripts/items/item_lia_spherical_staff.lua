item_ultimate_scepter = class({})
LinkLuaModifier("modifier_spherical_staff", "items/modifier_spherical_staff.lua", LUA_MODIFIER_MOTION_NONE)

function item_ultimate_scepter:GetIntrinsicModifierName()
	return "modifier_spherical_staff"
end

function item_ultimate_scepter:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_ultimate_scepter:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stunDuration = self:GetSpecialValueFor("stun_duration")
	local golemLifeTime = self:GetSpecialValueFor("infernal_duration")

	local pFX = ParticleManager:CreateParticle("particles/custom/items/spherical_staff_infernal.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pFX, 0, point + Vector(500,500,1300))
	ParticleManager:SetParticleControl(pFX, 1, point)
	ParticleManager:SetParticleControl(pFX, 2, Vector(1.3,0,0))
	ParticleManager:ReleaseParticleIndex(pFX)

	EmitSoundOnLocationWithCaster(point, "DOTA_Item.MeteorHammer.Cast", caster)

	Timers:CreateTimer(1.3, function() 
		local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),
			point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED,
			FIND_ANY_ORDER,
			false)	

		local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}

		for _,unit in pairs(targets) do
			unit:AddNewModifier(caster,self,"modifier_stunned",{ duration = stunDuration })
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end

		local golem = CreateUnitByName("spherical_staff_fire_golem", point, true, caster, caster, caster:GetTeamNumber())
		golem:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		golem:AddNewModifier(caster,self,"modifier_kill",{duration = golemLifeTime})
		golem:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(golem:GetAbsOrigin(),65)

		EmitSoundOnLocationWithCaster(point,"DOTA_Item.MeteorHammer.Impact",caster)

	end)
end