if modifier_lia_shadow == nil then
	modifier_lia_shadow = class({})
end

function modifier_lia_shadow:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_lia_shadow:IsHidden()
	return true
end

function modifier_lia_shadow:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_lia_shadow:StatusEffectPriority()
	return 100
end

function modifier_lia_shadow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IS_ILLUSION,
		MODIFIER_PROPERTY_SUPER_ILLUSION,
		--MODIFIER_PROPERTY_ILLUSION_LABEL
	}
 
	return funcs
end


function modifier_lia_shadow:GetIsIllusion()
	return true
end

function modifier_lia_shadow:GetModifierSuperIllusion()
	return true 
end

function modifier_lia_shadow:GetModifierIllusionLabel()
	return true
end