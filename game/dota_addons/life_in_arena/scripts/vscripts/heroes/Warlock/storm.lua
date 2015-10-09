
function stormCauseDamage(keys)

	--local heroCaster = keys.heroCaster
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = keys.damage

	--DebugDrawText(caster:GetAbsOrigin(), "1", true, 4)	
	--caster:ReduceMana(1000)

	if caster:HasModifier('modifier_warlock_storm_hero') then
		ApplyDamage(
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end

end

function stormEffect(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor( "radius" )
	local castPoint = keys.ability.castPoint
	local particleName = "particles/units/heroes/hero_zuus/zuus_lightning_bolt_child_b.vpcf"
	--local particleName2 = "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf"
	
	--"particles/units/heroes/hero_zuus/zuus_lightning_bolt_child_b.vpcf"
	--particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_e.vpcf
	--
	--particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf
	--particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf
	
	local attackPoint1 = Vector( castPoint.x, castPoint.y, castPoint.z )
	local attackPoint2 = Vector( castPoint.x-(radius-50), castPoint.y-(radius-50), castPoint.z )
	local attackPoint3 = Vector( castPoint.x+(radius-50), castPoint.y-(radius-50), castPoint.z )
	local attackPoint4 = Vector( castPoint.x+(radius-50), castPoint.y+(radius-50), castPoint.z )
	local attackPoint5 = Vector( castPoint.x-(radius-50), castPoint.y+(radius-50), castPoint.z )
	--
	-- Fire effect
	-- PATTACH_POINT
	-- PATTACH_CUSTOMORIGIN
	local fxIndex1 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex1, 0, attackPoint1 )
	--
	local fxIndex2 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex2, 0, attackPoint2 )
	--
	local fxIndex3 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex3, 0, attackPoint3 )
	--
	local fxIndex4 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex4, 0, attackPoint4 )
	--
	local fxIndex5 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex5, 0, attackPoint5 )
	--
	--
	--
	--local fxIndex11 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT, caster)
	--ParticleManager:SetParticleControl( fxIndex11, 1, attackPoint1 )
	--
	--local fxIndex12 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT, caster)
	--ParticleManager:SetParticleControl( fxIndex12, 1, attackPoint2 )
	--
	--local fxIndex13 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT, caster)
	--ParticleManager:SetParticleControl( fxIndex13, 1, attackPoint3 )
	--
	--local fxIndex14 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT, caster)
	--ParticleManager:SetParticleControl( fxIndex14, 1, attackPoint4 )
	--
	--local fxIndex15 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT, caster)
	--ParticleManager:SetParticleControl( fxIndex15, 1, attackPoint5 )

end