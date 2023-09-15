modifier_ultimate_upgrade = class({})

--------------------------------------------------------------------------------

function modifier_ultimate_upgrade:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ultimate_upgrade:IsPurgable()
	return false
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function modifier_ultimate_upgrade:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_IS_SCEPTER,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ultimate_upgrade:GetModifierScepter()
	return 1
end