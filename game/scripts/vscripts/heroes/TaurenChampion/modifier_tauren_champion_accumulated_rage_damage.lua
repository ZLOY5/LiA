
modifier_tauren_champion_accumulated_rage_damage = class({})


function modifier_tauren_champion_accumulated_rage_damage:GetTexture() 
	return "custom/tauren_champion_accumulated_rage_damage"
end

function modifier_tauren_champion_accumulated_rage_damage:IsHidden()
	return false
end

function modifier_tauren_champion_accumulated_rage_damage:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage_damage:OnCreated(kv)
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.health_lost_threshold_percent = self:GetAbility():GetSpecialValueFor("health_lost_threshold_percent")
	if IsServer() then
		self:SetStackCount(0)
		self.accumulatedRageDamage = ParticleManager:CreateParticle( "particles/custom/tauren_champion/modifier_tauren_champion_accumulated_rage_damage.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.accumulatedRageDamage, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin() + Vector(0,0,-50), true)
	end
end

function modifier_tauren_champion_accumulated_rage_damage:OnRefresh(kv)
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.health_lost_threshold_percent = self:GetAbility():GetSpecialValueFor("health_lost_threshold_percent")
end

function modifier_tauren_champion_accumulated_rage_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end


function modifier_tauren_champion_accumulated_rage_damage:GetModifierPreAttack_BonusDamage(params)
		if self:GetParent():PassivesDisabled() then
			return 0
		end

		local bonusDamage = math.floor((100 - self:GetParent():GetHealthPercent()) / self.health_lost_threshold_percent) * self.damage_per_stack + self.damage_per_stack
		self:SetStackCount(bonusDamage)
		return bonusDamage
end

function modifier_tauren_champion_accumulated_rage_damage:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.accumulatedRageDamage, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_accumulated_rage_block", nil)
	end
end


