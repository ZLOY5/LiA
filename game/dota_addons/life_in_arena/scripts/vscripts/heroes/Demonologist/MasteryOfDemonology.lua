function OnSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local health_transfered = caster:GetHealth() * ability:GetSpecialValueFor("hp_percent_transfer") * 0.01

	caster:SetHealth(caster:GetHealth() - health_transfered)
	target:SetHealth(target:GetHealth() + health_transfered)
	
end

function GiveAbility(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if not target:IsIllusion() then
		if not target:HasAbility("demonologist_mastery_of_demonology_creep") then	
			target:AddAbility("demonologist_mastery_of_demonology_creep")
			local given_ability = target:FindAbilityByName("demonologist_mastery_of_demonology_creep")
			given_ability:SetLevel(ability:GetLevel())
		--	ability:ApplyDataDrivenModifier(caster,target,"modifier_mastery_of_demonology_buff",nil)
		end
	end
	
end
