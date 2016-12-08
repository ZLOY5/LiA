item_lia_lunar_necklace = class({})
LinkLuaModifier("modifier_item_lia_lunar_necklace","items/item_lia_lunar_necklace.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_lunar_necklace_buff","items/item_lia_lunar_necklace.lua",LUA_MODIFIER_MOTION_NONE)


function item_lia_lunar_necklace:GetIntrinsicModifierName()
	return "modifier_item_lia_lunar_necklace"
end

function item_lia_lunar_necklace:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()

	target:EmitSound("Hero_Luna.Eclipse.Cast")

	local particle = ParticleManager:CreateParticle("particles/luna_eclipse_small.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:ReleaseParticleIndex(particle)
	target:AddNewModifier(caster,self,"modifier_item_lia_lunar_necklace_buff",{duration = duration})

end

-------------------------------------------------------------------------------

modifier_item_lia_lunar_necklace = class({})

function modifier_item_lia_lunar_necklace:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_lunar_necklace:IsHidden()
	return true 
end

function modifier_item_lia_lunar_necklace:IsPurgable()
	return false 
end

function modifier_item_lia_lunar_necklace:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	    MODIFIER_PROPERTY_HEALTH_BONUS,
	    MODIFIER_PROPERTY_MANA_BONUS
	}
 
	return funcs
end

function modifier_item_lia_lunar_necklace:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_item_lia_lunar_necklace:GetModifierManaBonus()
	return self.manaBonus
end

function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Agility()
	return self.statsBonus
end

function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Intellect()
	return self.statsBonus
end
function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Strength()
	return self.statsBonus
end

function modifier_item_lia_lunar_necklace:OnCreated(kv)
	self.statsBonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.manaBonus = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

-----------------------------------------------------------------------------------------

modifier_item_lia_lunar_necklace_buff = class({})

function modifier_item_lia_lunar_necklace_buff:IsBuff()
	return true
end

function modifier_item_lia_lunar_necklace_buff:IsPurgable()
	return false 
end

function modifier_item_lia_lunar_necklace_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
 
	return funcs
end

function modifier_item_lia_lunar_necklace_buff:GetModifierBonusStats_Agility()
	self.strenghtBonus = self:GetAbility():GetSpecialValueFor("stat_percent") * 
	return self.statsBonus
end

function modifier_item_lia_lunar_necklace_buff:GetModifierBonusStats_Intellect()
	return self.statsBonus
end
function modifier_item_lia_lunar_necklace_buff:GetModifierBonusStats_Strength()
	return self.statsBonus
end

function modifier_item_lia_lunar_necklace_buff:OnCreated(kv)
	self.statsBonusPercent = self:GetAbility():GetSpecialValueFor("stat_percent")
	self.magicResist = self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_lia_lunar_necklace_buff:GetEffectName()
	return "particles/luna_eclipse_cast_moonlight_glow_ti_5.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_item_lia_lunar_necklace_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end