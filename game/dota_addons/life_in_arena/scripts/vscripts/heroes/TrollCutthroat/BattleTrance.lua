function EnableWhirl(keys)
	local caster = keys.caster
	local ability = keys.ability

	local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")

	if whirl ~= nil then
		whirl:SetActivated(true)
	end
end

function DisableWhirl(keys)
	local caster = keys.caster
	local ability = keys.ability

	local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")

	if whirl ~= nil and not caster:HasModifier("modifier_troll_cutthroat_battle_trance") and not caster:HasModifier("modifier_troll_cuthroat_boomeang_axe_disarm") then
		whirl:SetActivated(false)
	end	
end