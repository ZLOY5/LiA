--[[
	Author: Noya
	Date: 25.01.2015.
	Creates a dummy unit to apply the Blizzard thinker modifier which does the waves
]]
function BlizzardStart( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
						--npc_dummy_blank
	caster.blizzard_dummy = CreateUnitByName("dummy_unit", point, false, caster, caster, caster:GetTeam())
	local modifier = event.ability:ApplyDataDrivenModifier(caster, caster.blizzard_dummy, "modifier_blizzard_thinker", nil)
	modifier:SetDuration(ability:GetSpecialValueFor("wave_interval") * ability:GetSpecialValueFor("wave_count") + 0.7, true)
end

-- -- Create the particles with small delays between each other
function BlizzardWave( event )
	local caster = event.caster
	local ability = event.ability

	local damage = ability:GetSpecialValueFor("wave_damage")
	local stun_duration = ability:GetSpecialValueFor("stun")
	local radius = ability:GetSpecialValueFor("radius")

	local target_position = event.target:GetAbsOrigin() --event.target_points[1]
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
    local distance = 100

    -- Center explosion
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, target_position )

	local fv = caster:GetForwardVector()
    local distance = 100

    Timers:CreateTimer(0.05,function()
    local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle2, 0, target_position+RandomVector(100) ) end)

    Timers:CreateTimer(0.1,function()
	local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle3, 0, target_position-RandomVector(100) ) end)

    Timers:CreateTimer(0.15,function()
	local particle4 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle4, 0, target_position+RandomVector(RandomInt(50,100)) ) end)

    Timers:CreateTimer(0.2,function()
	local particle5 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle5, 0, target_position-RandomVector(RandomInt(50,100)) ) end)

    --print(target_position)

    Timers:CreateTimer(0.65, function()

    	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
    		target_position,
    		nil,
    		radius,
    		DOTA_UNIT_TARGET_TEAM_ENEMY,
    		DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
    		DOTA_UNIT_TARGET_FLAG_NONE,
    		FIND_ANY_ORDER,
    		false)

    	for _,unit in pairs(targets) do
    		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
    		unit:AddNewModifier(caster,ability,"modifier_stunned",{duration = stun_duration})
    	end

    	EmitSoundOn("hero_Crystal.freezingField.explosion",event.target)

    	end)
end



function BlizzardEnd( event )
	local caster = event.caster

	caster.blizzard_dummy:RemoveSelf()
	--caster:ReduceMana(1000)
end