function illusions( event )
	local caster = event.caster
	--local target = event.target
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	if not caster.count_ill then
		caster.count_ill=0
	end
	
	local duration = ability:GetLevelSpecialValueFor( "time", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )

	local attacker = event.attacker
	--if not string.find(attacker:GetName(),"megaboss") then 
	if string.find(attacker:GetName(),"megaboss") then
		ability:RefundManaCost()
		ability:EndCooldown()
		--FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_item_lia_staff_of_illusions_megaboss" } )
		return
	end
	local creep = MakeIllusion(event)
	--
	--if caster.count_ill then
	caster.count_ill = caster.count_ill +1
	--end
	
	if not caster.curr_agi then
		caster.curr_agi = 0
	end
	
	-- дадим ловкость Антаро за каждую вызванную иллюзию: повесим модификатор, где будем все делать
	local ability2 = caster:FindAbilityByName('illusionist_agility_paws')
	if ability2:GetLevel() > 0 then
		local bonus_agi = ability2:GetLevelSpecialValueFor( "bonus_agility", ability2:GetLevel() - 1 )
		local max_bonus = ability2:GetLevelSpecialValueFor( "max_bonus", ability2:GetLevel() - 1 )
		--local modifier = FindModifierByName()
		if max_bonus > caster.curr_agi then
			caster.curr_agi = caster.curr_agi + bonus_agi
			caster:ModifyAgility(bonus_agi)
			caster:CalculateStatBonus()
			creep.bonus_agi = bonus_agi -- чтобы каждый крип знал сколько он добавил ловки герою
			ability2:ApplyDataDrivenModifier(caster, creep, "modifier_illusionist_agility_paws", {})
		end
	end
	
	
	
--[[	if not target:IsHero() then
		creep = CreateUnitByName(attacker:GetUnitName(), attacker:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		creep:SetControllableByPlayer(caster:GetPlayerID(), true)
		creep:AddNewModifier(caster, event.ability, "modifier_kill", {duration = duration})
		--creep:AddNewModifier(caster, event.ability, "modifier_illusion", nil)
		--event.ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_ranger_black_arrow_unit", nil)
		creep:SetRenderColor(149, 127, 227)
		creep:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		creep:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		creep:MakeIllusion()
		creep:SetAcquisitionRange(800)
		--if caster.count_ill = nil then
		caster.count_ill = caster.count_ill +1
		--else
	else
		
		local casterAngles = caster:GetAngles()
		local casterForward = caster:GetForwardVector()
		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local creep = CreateUnitByName(attacker:GetUnitName(), attacker:GetAbsOrigin(), true, caster, nil, caster:GetTeamNumber())
		creep:SetOwner(caster)
	
		creep:SetPlayerID(caster:GetPlayerID())
		creep:SetControllableByPlayer(caster:GetPlayerID(), true)
		
		creep:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		creep:SetForwardVector(casterForward)
		
		-- Level Up the unit to the casters level
		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			creep:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the caster
		creep:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local abilityy = caster:GetAbilityByIndex(abilitySlot)
			if abilityy ~= nil then 
				local abilityLevel = abilityy:GetLevel()
				local abilityName = abilityy:GetAbilityName()
				local illusionAbility = creep:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end

		-- Recreate the items of the caster
		for itemSlot=0,5 do
			local item = caster:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, creep, creep)
				creep:AddItem(newItem)
			end
		end
		
		-- set life and mana illusion
		creep:SetMana(caster:GetMana())
		creep:SetHealth(caster:GetHealth())

		creep:SetBaseAgility(caster:GetBaseAgility())
		creep:SetBaseIntellect(caster:GetBaseIntellect())
		creep:SetBaseStrength(caster:GetBaseStrength())
		creep:CalculateStatBonus()

		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		creep:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		creep:MakeIllusion()
	
	end
]]


	--end

end


function MakeIllusion(keys)
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target = keys.attacker --target
	local unit_name = target:GetUnitName()
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "time", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )
	local hPlayer = caster:GetPlayerOwner()

	--if string.find(unit_name,"megaboss") then
	--	ability:RefundManaCost()
	--	ability:EndCooldown()
		--FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_item_lia_staff_of_illusions_megaboss" } )
	--	return
	--end

	local origin = target:GetAbsOrigin() -- + ( target:GetForwardVector() * 150 )
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
	illusion:SetForwardVector(target:GetForwardVector())
	illusion:SetControllableByPlayer(player, true)
	illusion:SetOwner(caster)
	if target:IsRealHero() then
		illusion:SetPlayerID(caster:GetPlayerID())
		illusion:SetOwner(hPlayer)
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
			--print(abilityName,abilityLevel)
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
	--
	return illusion
end


--[[function init( event )
	local caster = event.caster
	caster.count_ill = 0
	

end

]]