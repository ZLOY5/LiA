function Dominate(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	local duration = keys.ability:GetSpecialValueFor("duration")
	local ability = keys.ability
	
	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") and not v:IsIllusion() and not v:IsHero() then --проверяем не босс или не мегабосс ли юнит
			local modifierKill = v:FindModifierByName("modifier_kill")
			local health = v:GetHealth()
			local mana = v:GetMana()
			local forwardVector = v:GetForwardVector() 
			local owner_id
			local owner = v:GetOwner()
			local lifetime
			if owner ~= nil then
				owner_id = owner:GetPlayerID()
			end

			if modifierKill then
				lifetime = modifierKill:GetRemainingTime()
			end
			v:AddNoDraw()
			v.no_corpse = true 
			v.beastmasterDominated = true
			v:ForceKill(false)

			
			
			bmcreep = CreateUnitByName(v:GetUnitName(), v:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			bmcreep:SetForwardVector(forwardVector)
			bmcreep:SetHealth(health)
			bmcreep:SetMana(mana)
			bmcreep:SetControllableByPlayer(caster:GetPlayerID(), true)
		--	bmcreep:AddNewModifier(bmcreep, nil, "modifier_kill", {duration = duration})
			if modifierKill then
				bmcreep:AddNewModifier(bmcreep, nil, "modifier_kill", {duration = lifetime})
			end
			keys.ability:ApplyDataDrivenModifier(caster,bmcreep,"modifier_beastmaster_dominate_kill",nil)
			bmcreep.previousOwner = owner
			bmcreep.previousOwnerID = owner_id
			bmcreep.dominateStartTime = GameRules:GetGameTime()
			bmcreep.beastmasterDominated = true
			
			ResolveNPCPositions(bmcreep:GetAbsOrigin(),65)
		else 
			ApplyDamage({victim = v, attacker = caster, damage = keys.ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})
		end
	end 
end


function OnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierKill = target:FindModifierByName("modifier_kill")
	local lifetime
	target.dominateEndTime = GameRules:GetGameTime()
	

	if target.dominateEndTime - target.dominateStartTime >= 10 then
		local preDeathHP = target:GetHealth()
		local preDeathMP = target:GetMana()
		local forwardVector = target:GetForwardVector() 
		if modifierKill then
			lifetime = modifierKill:GetRemainingTime()
		end
		target:AddNoDraw()
		target:ForceKill(false)
		if target.previousOwner ~= nil then
			local newcreep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, target.previousOwner, target.previousOwner, target.previousOwner:GetTeamNumber())
			newcreep:SetControllableByPlayer(target.previousOwnerID, true)
			newcreep:SetHealth(preDeathHP)
			newcreep:SetMana(preDeathMP)
			newcreep:SetForwardVector(forwardVector)
			if modifierKill then
				newcreep:AddNewModifier(newcreep, nil, "modifier_kill", {duration = lifetime})
			end
			ResolveNPCPositions(newcreep:GetAbsOrigin(),65)
		else
			local newcreep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
			newcreep:SetHealth(preDeathHP)
			newcreep:SetHealth(preDeathMP)
			newcreep:SetForwardVector(forwardVector)
			if modifierKill then
				newcreep:AddNewModifier(newcreep, nil, "modifier_kill", {duration = lifetime})
			end
			ResolveNPCPositions(newcreep:GetAbsOrigin(),65)
		end
	else
		local creepForGold = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
		--creepForGold.beastmasterDominated = true
		creepForGold:AddNoDraw()
		creepForGold:Kill(ability, caster)
	end
end