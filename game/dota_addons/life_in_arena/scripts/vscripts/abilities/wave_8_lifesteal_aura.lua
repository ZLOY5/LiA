wave_8_lifesteal_aura = class({})
LinkLuaModifier("modifier_wave_8_lifesteal_aura","abilities/wave_8_lifesteal_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_8_lifesteal_aura_effect","abilities/wave_8_lifesteal_aura.lua",LUA_MODIFIER_MOTION_NONE)

function wave_8_lifesteal_aura:GetIntrinsicModifierName()
	return "modifier_wave_8_lifesteal_aura"
end

-------------------------------------------------------------------------------

modifier_wave_8_lifesteal_aura = class({})

function modifier_wave_8_lifesteal_aura:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_wave_8_lifesteal_aura:IsHidden()
	return true 
end

function modifier_wave_8_lifesteal_aura:IsPurgable()
	return false 
end


function modifier_wave_8_lifesteal_aura:IsAura()
	return true
end

function modifier_wave_8_lifesteal_aura:GetAuraRadius()
	return self.radius
end

function modifier_wave_8_lifesteal_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_wave_8_lifesteal_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_wave_8_lifesteal_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_wave_8_lifesteal_aura:GetAuraDuration()
	return 1
end

function modifier_wave_8_lifesteal_aura:GetModifierAura()
	if self:GetParent():PassivesDisabled() then
		return
	end
	return "modifier_wave_8_lifesteal_aura_effect"
end

function modifier_wave_8_lifesteal_aura:OnCreated(kv)
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

-----------------------------------------------------------------------------------------

modifier_wave_8_lifesteal_aura_effect = class({})

function modifier_wave_8_lifesteal_aura_effect:IsBuff()
	return true
end

function modifier_wave_8_lifesteal_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_wave_8_lifesteal_aura_effect:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and not params.ranged_attack then 
		self.attack_record = params.record
	end
end

function modifier_wave_8_lifesteal_aura_effect:OnTakeDamage(params)
	if self.attack_record == params.record then
		local lifesteal = params.damage * self.lifestealPercent 
		params.attacker:Heal(lifesteal,self:GetAbility())
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, lifesteal, nil)
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_wave_8_lifesteal_aura_effect:OnCreated(kv)
	self.lifestealPercent = self:GetAbility():GetSpecialValueFor("aura_lifesteal_percent") * 0.01
end