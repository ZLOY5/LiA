

function Storm(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local castPoint = ability:GetCursorPosition()
	
	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
										castPoint,
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,target in pairs(targets) do
		ApplyDamage({victim = target, attacker = caster, ability = ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
	end

	local particleName = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"

	local attackPoint1 = Vector( castPoint.x, castPoint.y, castPoint.z )
	local attackPoint2 = Vector( castPoint.x-(radius-50), castPoint.y-(radius-50), castPoint.z )
	local attackPoint3 = Vector( castPoint.x+(radius-50), castPoint.y-(radius-50), castPoint.z )
	local attackPoint4 = Vector( castPoint.x+(radius-50), castPoint.y+(radius-50), castPoint.z )
	local attackPoint5 = Vector( castPoint.x-(radius-50), castPoint.y+(radius-50), castPoint.z )

	local fxIndex1 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex1, 0, attackPoint1 )
	ParticleManager:SetParticleControl( fxIndex1, 1, Vector( castPoint.x, castPoint.y, castPoint.z+1000 ) )
	ParticleManager:ReleaseParticleIndex(fxIndex1)
	--
	--[[local fxIndex2 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex2, 0, attackPoint2 )
	ParticleManager:ReleaseParticleIndex(fxIndex2)
	--
	local fxIndex3 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex3, 0, attackPoint3 )
	ParticleManager:ReleaseParticleIndex(fxIndex3)
	--
	local fxIndex4 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex4, 0, attackPoint4 )
	ParticleManager:ReleaseParticleIndex(fxIndex4)
	--
	local fxIndex5 = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl( fxIndex5, 0, attackPoint5 )
	ParticleManager:ReleaseParticleIndex(fxIndex5)]]

end