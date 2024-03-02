modifier_valkyrie_rage = class({})

function modifier_valkyrie_rage:IsHidden() return false end
function modifier_valkyrie_rage:IsPurgable() return false end
function modifier_valkyrie_rage:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_valkyrie_rage:OnCreated(kv)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_valkyrie_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_valkyrie_rage:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			local hAttacker = params.attacker

			if hTarget ~= nil and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
				local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, self.radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)


				for _,v in pairs (targets) do	
					ApplyDamage({ victim = v, attacker = params.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
					local particle = ParticleManager:CreateParticle("particles/pa_arcana_phantom_strike_end_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
					ParticleManager:SetParticleControl(particle, 1, v:GetAbsOrigin())
				end
			end
		end
	end

	return 0.0
end

-- function modifier_valkyrie_rage:GetEffectName()
-- 	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_trail03.vpcf"
-- end

-- function modifier_valkyrie_rage:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end