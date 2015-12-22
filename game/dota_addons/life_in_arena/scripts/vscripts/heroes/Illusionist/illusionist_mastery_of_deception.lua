function illusions( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()

	local duration = ability:GetLevelSpecialValueFor( "time", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )

	local attacker = event.attacker
	if not string.find(attacker:GetName(),"megaboss") then 
		local creep = CreateUnitByName(attacker:GetUnitName(), attacker:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		creep:SetControllableByPlayer(caster:GetPlayerID(), true)
		creep:AddNewModifier(caster, event.ability, "modifier_kill", {duration = duration})
		--creep:AddNewModifier(caster, event.ability, "modifier_illusion", nil)
		--event.ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_ranger_black_arrow_unit", nil)
		creep:SetRenderColor(149, 127, 227)
		creep:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		creep:MakeIllusion()
		creep:SetAcquisitionRange(800)
		--if caster.count_ill = nil then
		caster.count_ill = caster.count_ill +1
		--else
		-- дадим ловкость Антаро за каждую вызванную иллюзию: повесим модификатор, где будем все делать
		local ability2 = caster:FindAbilityByName('illusionist_agility_paws')
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

end

function init( event )
	local caster = event.caster
	caster.count_ill = 0
	caster.curr_agi = 0

end

