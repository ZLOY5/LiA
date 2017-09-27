wave_8_lifesteal_extreme = class({})

LinkLuaModifier("modifier_wave_8_lifesteal_extreme_effect","abilities/wave_8_lifesteal_extreme.lua",LUA_MODIFIER_MOTION_NONE)

function wave_8_lifesteal_extreme:GetIntrinsicModifierName()
	return "modifier_wave_8_lifesteal_extreme_effect"
end


-----------------------------------------------------------------------------------------

modifier_wave_8_lifesteal_extreme_effect = class({})

function modifier_wave_8_lifesteal_extreme_effect:IsHidden()
	return true 
end

function modifier_wave_8_lifesteal_extreme_effect:IsPurgable()
	return false 
end

function modifier_wave_8_lifesteal_extreme_effect:IsBuff()
	return true
end

function modifier_wave_8_lifesteal_extreme_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_wave_8_lifesteal_extreme_effect:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and not params.ranged_attack then 
		self.attack_record = params.record
	end
end

function modifier_wave_8_lifesteal_extreme_effect:OnTakeDamage(params)
	if self.attack_record == params.record then
		local lifesteal = params.damage * self.lifestealPercent 
		params.attacker:Heal(lifesteal,self:GetAbility())
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, lifesteal, nil)
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_wave_8_lifesteal_extreme_effect:OnCreated(kv)
	self.lifestealPercent = self:GetAbility():GetSpecialValueFor("lifesteal_percent") * 0.01
end