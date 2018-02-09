modifier_warlock_firestorm_channel = class ({})

function modifier_warlock_firestorm_channel:IsHidden()
	return true
end

function modifier_warlock_firestorm_channel:IsPurgable()
	return false
end

function modifier_warlock_firestorm_channel:OnCreated(kv)
	self.wave_interval = self:GetAbility():GetSpecialValueFor("wave_interval")
	self.burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
	
	if self:GetCaster():HasScepter() then
		self.damage = self:GetSpecialValueFor( "damage_scepter" )
		self.radius = self:GetSpecialValueFor( "radius_scepter" )
	else
		self.damage = self:GetSpecialValueFor( "damage" )
		self.radius = self:GetSpecialValueFor( "radius" )
	end

	self.target_point = self:GetAbility().target_point

	if IsServer() then
		self:StartIntervalThink(self.wave_interval)
	end
end
 
function modifier_warlock_firestorm_channel:GetEffectName()
	return "particles/custom/dark_knight/dark_knight_dark_energy_zone_buff.vpcf"
end

function modifier_warlock_firestorm_channel:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_warlock_firestorm_channel:OnDestroy()
	if IsServer() then
		
	end
end

function modifier_warlock_firestorm_channel:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()

		local firestormTargets = FindUnitsInRadius(caster:GetTeam(), 
																self.target_point, 
																nil, self.radius, 
																DOTA_UNIT_TARGET_TEAM_ENEMY, 
																DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
																0, 
																FIND_ANY_ORDER, 
																false)

	    local firestorm = ParticleManager:CreateParticle("particles/custom/neutral/firestorm_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(firestorm, 0, self.target_point)
	    ParticleManager:SetParticleControl(firestorm, 4, Vector(self.radius, 1, 1))

	    caster:EmitSound("Hero_AbyssalUnderlord.Firestorm.Cast")

	    for _,v in pairs(firestormTargets) do
				ApplyDamage({ victim = v, attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
				v:AddNewModifier(caster, self:GetAbility(), "modifier_warlock_firestorm_burn", {duration = self.burn_duration})
		end
	end
end