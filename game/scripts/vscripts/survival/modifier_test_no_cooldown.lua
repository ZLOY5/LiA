modifier_test_no_cooldown = class({})

function modifier_test_no_cooldown:IsPurgeException()
	return true 
end

function modifier_test_no_cooldown:IsHidden()
	return false
end

function modifier_test_no_cooldown:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
 
	return funcs
end


function modifier_test_no_cooldown:GetModifierPercentageCooldown()
	return 100
end