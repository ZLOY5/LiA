item_lia_banner_of_victory = class({})
LinkLuaModifier("modifier_banner_of_victory","items/item_lia_banner_of_victory.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_banner_of_victory_aura_effect","items/item_lia_banner_of_victory.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_banner_of_victory:GetIntrinsicModifierName()
	return "modifier_banner_of_victory"
end

-------------------------------------------------------------------------------

modifier_banner_of_victory = class({})

function modifier_banner_of_victory:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_banner_of_victory:IsHidden()
	return true 
end

function modifier_banner_of_victory:IsPurgable()
	return false 
end


function modifier_banner_of_victory:IsAura()
	return true
end

function modifier_banner_of_victory:GetAuraRadius()
	return self.radius
end

function modifier_banner_of_victory:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_banner_of_victory:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_banner_of_victory:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_banner_of_victory:GetAuraDuration()
	return 1
end

function modifier_banner_of_victory:GetModifierAura()
	return "modifier_banner_of_victory_aura_effect"
end

function modifier_banner_of_victory:OnCreated(kv)
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

-----------------------------------------------------------------------------------------

modifier_banner_of_victory_aura_effect = class({})

function modifier_banner_of_victory_aura_effect:IsBuff()
	return true
end

function modifier_banner_of_victory_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_banner_of_victory_aura_effect:GetModifierPhysicalArmorBonus()
	return self.armorBonus 
end

function modifier_banner_of_victory_aura_effect:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and not params.ranged_attack then 
		self.attack_record = params.record
	end
end

function modifier_banner_of_victory_aura_effect:OnTakeDamage(params)
	if self.attack_record == params.record and not params.attacker:HasModifier("modifier_ferus_shield_aura_effect") then
		local lifesteal = params.damage * self.lifestealPercent 
		params.attacker:Heal(lifesteal,self:GetAbility())
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, lifesteal, nil)
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_banner_of_victory_aura_effect:OnCreated(kv)
	self.lifestealPercent = self:GetAbility():GetSpecialValueFor("aura_lifesteal_percent") * 0.01
	self.armorBonus = self:GetAbility():GetSpecialValueFor("aura_armor")
end