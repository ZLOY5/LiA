function MakeIllusion(event)
	local caster = event.caster
	local player = caster:GetPlayerID()
	local target = event.target
	local unit_name = target:GetUnitName()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )

	if string.find(unit_name,"megaboss") then
		ability:RefundManaCost()
		ability:EndCooldown()
		FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_item_lia_staff_of_illusions_megaboss" } )
		return
	end

	local origin = target:GetAbsOrigin() + RandomVector(150)

	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetControllableByPlayer(player, true)
	
	if target:IsRealHero() then
		illusion:SetPlayerID(caster:GetPlayerID())
		local targetLevel = target:GetLevel()
		for i=1,targetLevel-1 do
			illusion:HeroLevelUp(false)
		end
		illusion:SetAbilityPoints(0)
	end

	
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	if target:HasInventory() then
		for itemSlot=0,5 do
			local item = target:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end
	end

	if target:IsRealHero() then
		illusion:SetBaseAgility(target:GetBaseAgility())
		illusion:SetBaseIntellect(target:GetBaseIntellect())
		illusion:SetBaseStrength(target:GetBaseStrength())
		illusion:CalculateStatBonus()
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
end