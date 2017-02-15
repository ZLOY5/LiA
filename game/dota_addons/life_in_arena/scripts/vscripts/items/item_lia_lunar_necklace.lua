item_lia_lunar_necklace = class({})
LinkLuaModifier("modifier_item_lia_lunar_necklace","items/item_lia_lunar_necklace.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_lunar_necklace_active","items/item_lia_lunar_necklace.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_lunar_necklace:GetIntrinsicModifierName()
	return "modifier_item_lia_lunar_necklace"
end

function item_lia_lunar_necklace:OnSpellStart()
	local target = self:GetCursorTarget()

	target:AddNewModifier(self:GetCaster(),self,"modifier_item_lia_lunar_necklace_active",{duration = self:GetSpecialValueFor("duration")})

	local particle = ParticleManager:CreateParticle("particles/luna_eclipse_small.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	ParticleManager:ReleaseParticleIndex(particle)
	
	EmitSoundOn("Hero_Luna.Eclipse.Cast",target)
end

----------------------------------------------------------------------

modifier_item_lia_lunar_necklace = class({})

function modifier_item_lia_lunar_necklace:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_lia_lunar_necklace:IsPurgable()
	return false
end

function modifier_item_lia_lunar_necklace:IsHidden()
	return true 
end

function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Strength()
	return self.strBonus 
end

function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Agility()
	return self.agiBonus 
end

function modifier_item_lia_lunar_necklace:GetModifierBonusStats_Intellect()
	return self.intBonus 
end

function modifier_item_lia_lunar_necklace:GetModifierHealthBonus()
	return self.healthBonus 
end

function modifier_item_lia_lunar_necklace:GetModifierManaBonus()
	return self.manaBonus 
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

function modifier_item_lia_lunar_necklace:OnCreated()
	self.strBonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.agiBonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.intBonus = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.manaBonus = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

-------------------------------------------------------------------------

modifier_item_lia_lunar_necklace_active = class({})

function modifier_item_lia_lunar_necklace_active:IsBuff()
	return true 
end

function modifier_item_lia_lunar_necklace_active:GetEffectName()
	return "particles/luna_eclipse_cast_moonlight_glow_ti_5.vpcf"
end

function modifier_item_lia_lunar_necklace_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

if IsServer() then

	function modifier_item_lia_lunar_necklace_active:GetModifierBonusStats_Strength()
		return self.strBonus 
	end

	function modifier_item_lia_lunar_necklace_active:GetModifierBonusStats_Agility()
		return self.agiBonus 
	end

	function modifier_item_lia_lunar_necklace_active:GetModifierBonusStats_Intellect()
		return self.intBonus 
	end

	function modifier_item_lia_lunar_necklace_active:GetModifierMagicalResistanceBonus()
		return self.magicResist
	end

	function modifier_item_lia_lunar_necklace_active:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
		}
	 
		return funcs
	end

	function modifier_item_lia_lunar_necklace_active:OnCreated()
		local percent = self:GetAbility():GetSpecialValueFor("stat_percent")
		local max = self:GetAbility():GetSpecialValueFor("stat_bonus_max")

		local strBonus = self:GetParent():GetBaseStrength() * percent / 100
		local agiBonus = self:GetParent():GetBaseAgility() * percent / 100
		local intBonus = self:GetParent():GetBaseIntellect() * percent / 100

		self.strBonus = strBonus <= max and strBonus or max
		self.agiBonus = agiBonus <= max and agiBonus or max
		self.intBonus = intBonus <= max and intBonus or max
		
		self.magicResist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist_percentage_active")
	end

end

