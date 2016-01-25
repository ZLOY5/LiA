function ApplyBuffs(event)
	local caster = event.caster
	local ability = event.ability

	local duration = ability:GetSpecialValueFor("duration")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_art_of_shadows_buff", {duration = duration})

	local abiShadow = caster:FindAbilityByName("shadow_master_shadow")
	if abiShadow and abiShadow.shadow and IsValidEntity(abiShadow.shadow) and abiShadow.shadow:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, abiShadow.shadow, "modifier_art_of_shadows_buff", {duration = duration})
	end

	local abiArt = caster:FindAbilityByName("shadow_master_art_of_shadows")
	if abiArt and abiArt.shadows then 
		for _,unit in pairs(abiArt.shadows) do
			if IsValidEntity(unit) and unit:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_art_of_shadows_buff", {duration = duration})
			end
		end
	end
end