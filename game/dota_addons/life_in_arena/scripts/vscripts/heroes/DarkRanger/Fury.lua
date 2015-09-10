function OnCreated(event)
	local caster = event.caster
	local ability1 = caster:FindAbilityByName("dark_ranger_black_arrow")
	local ability2 = caster:FindAbilityByName("dark_ranger_black_arrow_ultimate")
	ability2:SetLevel(ability1:GetLevel())
	if ability1:GetAutoCastState() ~= ability2:GetAutoCastState() then
		ability2:ToggleAutoCast()
	end
	event.caster:SwapAbilities("dark_ranger_black_arrow", "dark_ranger_black_arrow_ultimate", false, true)
	ability1:SetHidden(true)
	ability2:SetHidden(false)
	if ability1:GetAutoCastState() then 
		ability1:ToggleAutoCast()
	end
end

function OnDestroy(event)
	local caster = event.caster
	local ability2 = caster:FindAbilityByName("dark_ranger_black_arrow")
	local ability1 = caster:FindAbilityByName("dark_ranger_black_arrow_ultimate")
	ability2:SetLevel(ability1:GetLevel())
	if ability1:GetAutoCastState() ~= ability2:GetAutoCastState() then
		ability2:ToggleAutoCast()
	end
	event.caster:SwapAbilities("dark_ranger_black_arrow", "dark_ranger_black_arrow_ultimate", true, false)
	ability1:SetHidden(true)
	ability2:SetHidden(false)
	if ability1:GetAutoCastState() then 
		ability1:ToggleAutoCast()
	end
end