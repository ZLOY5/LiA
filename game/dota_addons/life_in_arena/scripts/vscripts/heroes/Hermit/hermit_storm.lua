
function createWave(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local target = keys.target
	--
	local wave_speed = ability:GetSpecialValueFor( "wave_speed" )
	local wave_width = ability:GetSpecialValueFor( "wave_width" )
	local vision_aoe = ability:GetSpecialValueFor( "vision_aoe" )
	local radius = ability:GetSpecialValueFor( "radius" )
	--print("radius ", radius)
	--
	-- Get random point
	local castPoint = caster:GetAbsOrigin()
	local attackPoint
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
	--print(attackPoint)
	--local ti = radius/wave_speed
	--
    local info = {
		Ability = ability,
		EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
		
		--"particles/units/heroes/hero_ancient_apparition/ancient_apparition_ambient.vpcf",
		
		--"particles/units/heroes/hero_tidehunter/tidehunter_gush_splash_water4c.vpcf",
		--"particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		Source = caster,
		vSpawnOrigin = attackPoint,
		vVelocity = caster:GetForwardVector() * wave_speed,
		fDistance = radius,
		--fExpireTime = GameRules:GetGameTime() + ti,
		--fMoveSpeed = wave_speed,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		bHasFrontalCone = true,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		fVisionRadius = vision_aoe,
		iVisionTeamNumber = caster:GetTeamNumber(),
		--bReplaceExisting = false,
		--bDeleteOnHit = true,
    }
    ProjectileManager:CreateLinearProjectile(info)
end


function CauseDamageDecor(event)
	local ability = event.ability
	local caster = event.caster
	--print("caster = ", caster:GetUnitName())
	--local target = event.target
	local targets = event.target_entities
	local damage = event.damage
	for _,v in pairs(targets) do
		if v.destructable == 1 then
			--print("try")
			ApplyDamage({victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		end
	end
end