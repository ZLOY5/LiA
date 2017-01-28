function OnSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local health_transfered = caster:GetHealth() * ability:GetSpecialValueFor("hp_percent_transfer") * 0.01
	local target_hp_difference = target:GetMaxHealth() - target:GetHealth()

	if event.target:GetHealthPercent() ~= 100 then
		if target_hp_difference > health_transfered then
	        caster:SetHealth(caster:GetHealth() - health_transfered)
			target:SetHealth(target:GetHealth() + health_transfered)
		else
			caster:SetHealth(caster:GetHealth() - target_hp_difference)
			target:SetHealth(target:GetHealth() + target_hp_difference)
		end
		local particle = ParticleManager:CreateParticle("particles/custom/demonologist/shadow_demon_demonic_purge_finale.vpcf", PATTACH_ABSORIGIN, caster)
		local particle2 = ParticleManager:CreateParticle("particles/custom/demonologist/shadow_demon_demonic_purge_finale.vpcf", PATTACH_ABSORIGIN, target)
		caster:EmitSound("Hero_ShadowDemon.DemonicPurge.Damage")
    else
        FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_target_at_full_health" } )
        event.ability:EndCooldown()
    end
	
	
end

function GiveAbility(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:GetOwner() == caster then
		if not target:IsIllusion() then
			if not target:HasAbility("demonologist_mastery_of_demonology_creep") then	
				target:AddAbility("demonologist_mastery_of_demonology_creep")
				local given_ability = target:FindAbilityByName("demonologist_mastery_of_demonology_creep")
				given_ability:SetLevel(ability:GetLevel())
				target:SetBaseMaxHealth(target:GetMaxHealth() + ability:GetSpecialValueFor("bonus_health"))
				target:SetHealth(target:GetHealth() + ability:GetSpecialValueFor("bonus_health"))
			--	ability:ApplyDataDrivenModifier(caster,target,"modifier_mastery_of_demonology_buff",nil)
			end
		end
	end
	
end
