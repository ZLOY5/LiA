modifier_huntress_moon_glaive = class({})

function modifier_huntress_moon_glaive:IsHidden()
	return true
end

function modifier_huntress_moon_glaive:IsPurgable()
	return false
end

function modifier_huntress_moon_glaive:OnCreated( kv )
	self.range = self:GetAbility():GetSpecialValueFor( "range" )
	self.bounces = self:GetAbility():GetSpecialValueFor( "bounces" )
	self.damage_reduction_percentage = self:GetAbility():GetSpecialValueFor( "damage_reduction_percentage" )
    if IsServer() then
        self.sProjectileName = self:GetParent():GetRangedProjectileName()
        self.iProjectileSpeed = self:GetParent():GetProjectileSpeed()
    end
end

function modifier_huntress_moon_glaive:OnRefresh( kv )
	self.range = self:GetAbility():GetSpecialValueFor( "range" )
	self.bounces = self:GetAbility():GetSpecialValueFor( "bounces" )
	self.damage_reduction_percentage = self:GetAbility():GetSpecialValueFor( "damage_reduction_percentage" )
end

function modifier_huntress_moon_glaive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_huntress_moon_glaive:OnAttackLanded(params)
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
            local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
											hTarget:GetAbsOrigin(), 
											nil, self.range, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                            FIND_CLOSEST, false)
            for k,v in pairs(targets) do
                if (v ~= hTarget) then
                    local info = {
                        EffectName = self.sProjectileName,
                        Ability = self:GetAbility(),
                        iMoveSpeed = self.iProjectileSpeed,
                        Source = hTarget,
                        Target = v,
                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                        ExtraData = {
                            bounces = 1,
                            projectile = self.sProjectileName,
                            speed = self.iProjectileSpeed,
                        }
                    }
    
                    ProjectileManager:CreateTrackingProjectile( info )
                    break
                end
            end

			
		end
	end

	return 0.0
end