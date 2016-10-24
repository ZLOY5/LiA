

function firestormWave_castpoint(keys)
	keys.ability.castPoint = keys.target_points[1]

end


function firestormWave(keys)

	--local heroCaster = keys.heroCaster
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	local exp_radius = ability:GetLevelSpecialValueFor( "exp_radius", ( ability:GetLevel() - 1 ) )
	--local castPoint = keys.pointCast   --caster:GetCastPoint(false)

	local castPoint = keys.ability.castPoint

        --print("POINT",1,castPoint)

	local particleName = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"

	local abilityDamage = ability:GetLevelSpecialValueFor( "wave_damage", ( ability:GetLevel() - 1 ) )
	--
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local damageType = ability:GetAbilityDamageType()

	
	--DebugDrawText(caster:GetAbsOrigin(), "1", true, 4)

	-- Get random point
	local castDistance = RandomInt( 0, radius )
	local angle = RandomInt( 0, 360 )
	local dy = castDistance * math.sin( angle )
	local dx = castDistance * math.cos( angle )
	local variant = RandomInt( 0, 4 )
	--
	if variant == 0 then			
		attackPoint = Vector( castPoint.x - dx, castPoint.y + dy, castPoint.z )
	elseif variant == 1 then		
		attackPoint = Vector( castPoint.x + dx, castPoint.y + dy, castPoint.z )
	elseif variant == 2 then		
		attackPoint = Vector( castPoint.x + dx, castPoint.y - dy, castPoint.z )
	else										
		attackPoint = Vector( castPoint.x - dx, castPoint.y - dy, castPoint.z )
	end

	
	local units = FindUnitsInRadius( caster:GetTeamNumber(), attackPoint, caster, exp_radius,
			targetTeam, targetType, targetFlag, 0, false )
	for k, v in pairs( units ) do
		local damageTable =
		{
			victim = v,
			attacker = caster,
			damage = abilityDamage,
			damage_type = damageType,
			ability = ability
		}
		ApplyDamage( damageTable )


		--burn units
		if caster:HasModifier('modifier_warlock_firestorm_burn') == false then
			ability:ApplyDataDrivenModifier( caster, v, 'modifier_warlock_firestorm_burn', {} )
		end
	end

	--
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )


end


function firestormWave_order( keys )
	local num = keys.wave_num_exp
	local interval = 0.1

	for i = 1, num, 1 do
		Timers:CreateTimer( interval*i, firestormWave(keys) )
	end
end