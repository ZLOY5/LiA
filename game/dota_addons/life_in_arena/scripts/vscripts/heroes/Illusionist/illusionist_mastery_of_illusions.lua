
function AddModifier(keys)
	local duration 
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	
	if not string.find(target:GetName(),"megaboss") then 
		if keys.target:IsHero() then
			duration = ability:GetSpecialValueFor("duration_hero")
		else
			duration = ability:GetSpecialValueFor("duration_other")
		end

		ability:ApplyDataDrivenModifier(caster, keys.target, 'modifier_illusionist_mastery_of_illusions', {duration = duration} )
		
		-- создадим иллюзии выбранного юнита
		local count_illusion = ability:GetSpecialValueFor("count_illusion")
		local life_illusion = ability:GetSpecialValueFor("life_illusion")
		local illus
		local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
		local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )
		-- дадим ловкость Антаро за каждую вызванную иллюзию: повесим модификатор, где будем все делать
		local ability2 = caster:FindAbilityByName('illusionist_agility_paws')
		local bonus_agi = ability2:GetLevelSpecialValueFor( "bonus_agility", ability2:GetLevel() - 1 )
		local max_bonus = ability2:GetLevelSpecialValueFor( "max_bonus", ability2:GetLevel() - 1 )
		for i=1,count_illusion do
			illus = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			illus:SetControllableByPlayer(caster:GetPlayerID(), true)
			illus:AddNewModifier(caster, ability, "modifier_kill", {duration = life_illusion})
			illus:SetRenderColor(149, 127, 227)
			illus:AddNewModifier(caster, ability, "modifier_illusion", { duration = life_illusion, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			illus:MakeIllusion()
			illus:SetAcquisitionRange(800)
			caster.count_ill = caster.count_ill +1
			--local modifier = FindModifierByName()
			if max_bonus > caster.curr_agi then
				caster.curr_agi = caster.curr_agi + bonus_agi
				caster:ModifyAgility(bonus_agi)
				caster:CalculateStatBonus()
				illus.bonus_agi = bonus_agi -- чтобы каждый крип знал сколько он добавил ловки герою
				ability2:ApplyDataDrivenModifier(caster, illus, "modifier_illusionist_agility_paws", {})
			end
		end


		
	end
	
end


