item_lia_ferus_shield = class({})
LinkLuaModifier("modifier_ferus_shield","items/item_lia_ferus_shield.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ferus_shield_aura_effect","items/item_lia_ferus_shield.lua",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ferus_shield_panic","items/item_lia_ferus_shield.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_ferus_shield:GetIntrinsicModifierName()
	return "modifier_ferus_shield"
end

function item_lia_ferus_shield:OnSpellStart()
	local caster = self:GetCaster()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("panic_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	local duration = self:GetSpecialValueFor("panic_duration")

	for _,unit in pairs(targets) do
		unit:AddNewModifier(caster,self,"modifier_ferus_shield_panic",{duration = duration})
	end

	caster:EmitSound("Hero_Sven.GodsStrength")

	local particle = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:ReleaseParticleIndex(particle)

end

-------------------------------------------------------------------------------

modifier_ferus_shield = class({})

function modifier_ferus_shield:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_ferus_shield:IsHidden()
	return true 
end

function modifier_ferus_shield:IsPurgable()
	return false 
end


function modifier_ferus_shield:IsAura()
	return true
end

function modifier_ferus_shield:GetAuraRadius()
	return self.radius
end

function modifier_ferus_shield:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_ferus_shield:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ferus_shield:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_ferus_shield:GetAuraDuration()
	return 1
end

function modifier_ferus_shield:GetModifierAura()
	return "modifier_ferus_shield_aura_effect"
end

function modifier_ferus_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
 
	return funcs
end

function modifier_ferus_shield:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_ferus_shield:GetModifierPreAttack_BonusDamage()
	return self.damageBonus
end

function modifier_ferus_shield:OnCreated(kv)
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	self.damageBonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
end

-----------------------------------------------------------------------------------------

modifier_ferus_shield_aura_effect = class({})

function modifier_ferus_shield_aura_effect:IsBuff()
	return true
end

function modifier_ferus_shield_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_ferus_shield_aura_effect:GetModifierConstantHealthRegen()
	return self.healthRegenBonus
end

function modifier_ferus_shield_aura_effect:GetModifierPhysicalArmorBonus()
	return self.armorBonus 
end

function modifier_ferus_shield_aura_effect:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and not params.ranged_attack then 
		self.attack_record = params.record
	end
end

function modifier_ferus_shield_aura_effect:OnTakeDamage(params)
	if self.attack_record == params.record then
		local lifesteal = params.damage * self.lifestealPercent 
		params.attacker:Heal(lifesteal,self:GetAbility())
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, lifesteal, nil)
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_ferus_shield_aura_effect:OnCreated(kv)
	self.lifestealPercent = self:GetAbility():GetSpecialValueFor("aura_lifesteal_percent") * 0.01
	self.armorBonus = self:GetAbility():GetSpecialValueFor("aura_armor")
	self.healthRegenBonus = self:GetAbility():GetSpecialValueFor("aura_regen")
end

------------------------------------------------------------------------------------------

modifier_ferus_shield_panic = class({})

function modifier_ferus_shield_panic:IsDebuff()
	return true
end

function modifier_ferus_shield_panic:IsPurgable()
	return true
end

function modifier_ferus_shield_panic:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_ferus_shield_panic:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end 

function modifier_ferus_shield_panic:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	}
 
	return state
end
