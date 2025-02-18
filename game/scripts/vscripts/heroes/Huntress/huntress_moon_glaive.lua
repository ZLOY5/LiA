huntress_moon_glaive = class({})
LinkLuaModifier("modifier_huntress_moon_glaive","heroes/Huntress/modifier_huntress_moon_glaive.lua",LUA_MODIFIER_MOTION_NONE)

function huntress_moon_glaive:GetIntrinsicModifierName()
	return "modifier_huntress_moon_glaive"
end

function huntress_moon_glaive:OnProjectileHit_ExtraData( hTarget, vLocation, ExtraData )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
        local damage_reduction_percentage = self:GetSpecialValueFor( "damage_reduction_percentage" )
        local range = self:GetSpecialValueFor( "range" )
        local max_bounces = self:GetSpecialValueFor( "bounces" )
        local damage_to_deal = ExtraData.damage * (1 - damage_reduction_percentage * 0.01) 

        if ExtraData.bounces < max_bounces then
            local targets = FindUnitsInRadius(self:GetCaster():GetTeam(), 
                                            hTarget:GetAbsOrigin(), 
                                            nil, range, 
                                            DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
                                            FIND_CLOSEST, false)
            for k,v in pairs(targets) do
                if (v ~= hTarget) then
                    local info = {
                        EffectName = ExtraData.projectile,
                        Ability = self,
                        iMoveSpeed = ExtraData.speed,
                        Source = hTarget,
                        Target = v,
                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                        ExtraData = {
                            bounces = ExtraData.bounces + 1,
                            projectile = ExtraData.projectile,
                            speed = ExtraData.speed,
                            damage = damage_to_deal
                        }
                    }

                    ProjectileManager:CreateTrackingProjectile( info )
                    break
                end
            end
        end
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return true
end

