modifier_alanith_spear_lua = class ({})

function modifier_sven_warcry_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end


function modifier_sven_warcry_lua:GetModifierPreAttack_BonusDamage(params)
	return 200
end