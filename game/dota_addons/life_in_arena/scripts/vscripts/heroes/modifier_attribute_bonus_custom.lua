modifier_attribute_bonus_custom = class({})

function modifier_attribute_bonus_custom:GetTexture() 
	return "attribute_bonus"
end

function modifier_attribute_bonus_custom:IsHidden()
    if self:GetParent():GetLevel() >= 12 then
        return false
    else
        return true
    end
end

function modifier_attribute_bonus_custom:IsPurgable()
	return false
end

function modifier_attribute_bonus_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
 
	return funcs
end

function modifier_attribute_bonus_custom:GetModifierBonusStats_Strength()
    local level = self:GetParent():GetLevel()
    if level == 12 then
        return 3
    else 
        if level >= 13 then
            return 3 * (level - 12)
        end
    end
end

function modifier_attribute_bonus_custom:GetModifierBonusStats_Agility()
	local level = self:GetParent():GetLevel()
    if level == 12 then
        return 3
    else 
        if level >= 13 then
            return 3 * (level - 12)
        end
    end
end

function modifier_attribute_bonus_custom:GetModifierBonusStats_Intellect()
	local level = self:GetParent():GetLevel()
    if level == 12 then
        return 3
    else 
        if level >= 13 then
            return 3 * (level - 12)
        end
    end
end