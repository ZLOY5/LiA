modifier_butcher_rage = class({})

function modifier_butcher_rage:IsHidden() return false end
function modifier_butcher_rage:IsPurgable() return false end
function modifier_butcher_rage:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_butcher_rage:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_butcher_rage:OnRefresh()
	self.hp_pct_to_dmg = self.ability:GetSpecialValueFor("hp_pct_to_dmg") * 0.01
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_butcher_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}
 
	return funcs
end

function modifier_butcher_rage:OnOrbImpact(event)
	if IsServer() then
		if self:GetParent() == event.attacker then
			local hTarget = event.target
			local hAttacker = event.attacker
			
			local damage_to_deal = hAttacker:GetHealth() * self.hp_pct_to_dmg

			if hTarget ~= nil and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
				local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
										hAttacker:GetAbsOrigin(), 
										nil, self.radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)


				for _,v in pairs (targets) do	
					ApplyDamage({ victim = v, attacker = event.attacker, damage = damage_to_deal, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
					ParticleManager:SetParticleControl(particle, 1, v:GetAbsOrigin())
				end
			end
		end
	end
end

function modifier_butcher_rage:GetAttackSound()
	return "Hero_Pudge.DismemberSwings"
end

function modifier_butcher_rage:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_trail03.vpcf"
end

function modifier_butcher_rage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end