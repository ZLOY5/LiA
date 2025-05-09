modifier_test_god_mode = class({})

function modifier_test_god_mode:IsPurgeException()
	return true 
end

function modifier_test_god_mode:IsHidden()
	return false
end

function modifier_test_god_mode:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}
 
	return funcs
end


function modifier_test_god_mode:GetModifierHealthBonus()
	return 100000
end

function modifier_test_god_mode:GetModifierPhysicalArmorBonus()
	return 1000
end

function modifier_test_god_mode:GetModifierConstantHealthRegen()
	return 5000
end

function modifier_test_god_mode:GetModifierMoveSpeedBonus_Special_Boots()
    return 500
end

function modifier_test_god_mode:GetModifierConstantManaRegen()
	return 2000
end

function modifier_test_god_mode:GetModifierManaBonus()
	return 10000
end

function modifier_test_god_mode:GetModifierStatusResistance()
	return 99
end