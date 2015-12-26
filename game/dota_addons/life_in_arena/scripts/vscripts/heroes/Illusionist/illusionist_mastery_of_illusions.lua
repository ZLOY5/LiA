
function AddModifier(keys)
	local duration 
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	if not caster.count_ill then
		caster.count_ill=0
	end
	--if not string.find(target:GetName(),"megaboss") then 
	if string.find(target:GetName(),"megaboss") then
		ability:RefundManaCost()
		ability:EndCooldown()
		--FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_item_lia_staff_of_illusions_megaboss" } )
		return
	end
	--
	if target:IsHero() then
		duration = ability:GetSpecialValueFor("duration_hero")
	else
		duration = ability:GetSpecialValueFor("duration_other")
	end

	ability:ApplyDataDrivenModifier(caster, target, 'modifier_illusionist_mastery_of_illusions', {duration = duration} )
	
	-- создадим иллюзии выбранного юнита
	local count_illusion = ability:GetSpecialValueFor("count_illusion")
	
	--local duration = ability:GetSpecialValueFor("life_illusion")
	local illus
	--local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
	--local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )
	-- дадим ловкость Антаро за каждую вызванную иллюзию: повесим модификатор, где будем все делать
	local ability2 = caster:FindAbilityByName('illusionist_agility_paws')
	local bonus_agi
	local max_bonus
	if ability2:GetLevel() > 0 then
		bonus_agi = ability2:GetLevelSpecialValueFor( "bonus_agility", ability2:GetLevel() - 1 )
		max_bonus = ability2:GetLevelSpecialValueFor( "max_bonus", ability2:GetLevel() - 1 )
	end
	--print('		target:GetUnitName()', target:GetUnitName())
	--print('		caster:GetUnitName()', caster:GetUnitName())
	
	if not caster.curr_agi then
		caster.curr_agi = 0
	end
	local ability3
	for i=1,count_illusion do
		illus = MakeIllusion(keys)	-- CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		--illus:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		--if not caster == target  then
		--illus:SetControllableByPlayer(caster:GetPlayerID(), true)
		ability3 = caster:FindAbilityByName('illusionist_whiff_of_deception')
		if ability3:GetLevel() > 0 then
			--
			--if caster.count_ill then
			caster.count_ill = caster.count_ill +1
			--end
			--
			-- отнимание коунтера по смерти иллюзии
			ability3:ApplyDataDrivenModifier(caster, illus, "modifier_illusionist_whiff_of_deception", {})
			
		end
		--if caster.count_ill then
--		caster.count_ill = caster.count_ill +1
		--end
		--local modifier = FindModifierByName()
		if ability2:GetLevel() > 0 then
			if max_bonus > caster.curr_agi then
				caster.curr_agi = caster.curr_agi + bonus_agi
				caster:ModifyAgility(bonus_agi)
				caster:CalculateStatBonus()
				illus.bonus_agi = bonus_agi -- чтобы каждый крип знал сколько он добавил ловки герою
				ability2:ApplyDataDrivenModifier(caster, illus, "modifier_illusionist_agility_paws", {})
			end
		end
	end
	--[[	illus:AddNewModifier(caster, ability, "modifier_kill", {duration = life_illusion})
		illus:SetRenderColor(149, 127, 227)
		illus:AddNewModifier(caster, ability, "modifier_illusion", { duration = life_illusion, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })

				
		illus:MakeIllusion()
		illus:SetAcquisitionRange(800)
		caster.count_ill = caster.count_ill +1
		--local modifier = FindModifierByName()
		if ability2 then
			if max_bonus > caster.curr_agi then
				caster.curr_agi = caster.curr_agi + bonus_agi
				caster:ModifyAgility(bonus_agi)
				caster:CalculateStatBonus()
				illus.bonus_agi = bonus_agi -- чтобы каждый крип знал сколько он добавил ловки герою
				ability2:ApplyDataDrivenModifier(caster, illus, "modifier_illusionist_agility_paws", {})
			end
		end
	end

]]
	
	--end
	
end

function MakeIllusion(keys)
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target = keys.target
	local unit_name = target:GetUnitName()
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "life_illusion", ability:GetLevel() - 1 )
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
