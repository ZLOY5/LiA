modifier_megaboss_status_resist = class({})

--------------------------------------------------------------------------------

function modifier_megaboss_status_resist:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_megaboss_status_resist:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_megaboss_status_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_megaboss_status_resist:GetModifierStatusResistance( params )
	local statusResist = 0.1 * Survival:GetHeroCount(false)
	return statusResist
end

--------------------------------------------------------------------------------

function modifier_megaboss_status_resist:OnCreated()
	local qwe = Survival:GetHeroCount(false)
	print(qwe)
end