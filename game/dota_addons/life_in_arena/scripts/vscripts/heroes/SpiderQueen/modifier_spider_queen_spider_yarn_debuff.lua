
modifier_spider_queen_spider_yarn_debuff = class({})

function modifier_spider_queen_spider_yarn_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_spider_queen_spider_yarn_debuff:IsHidden()
	return false
end

function modifier_spider_queen_spider_yarn_debuff:IsPurgable()
	return false
end

function modifier_spider_queen_spider_yarn_debuff:OnCreated(kv)
	self.miss_chance = self:GetAbility():GetSpecialValueFor("miss_chance")
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor("movement_slow_percentage")
end

function modifier_spider_queen_spider_yarn_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

function modifier_spider_queen_spider_yarn_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_spider_queen_spider_yarn_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percentage
end

function modifier_spider_queen_spider_yarn_debuff:GetEffectName()
	return "particles/units/heroes/hero_broodmother/broodmother_web_strand_parent_b.vpcf"
end

function modifier_spider_queen_spider_yarn_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

