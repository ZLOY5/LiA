function Spawn(entityKeyValues)

	ABILITY_Heal = thisEntity:FindAbilityByName("troll_healer_heal")
	ABILITY_Heal:ToggleAutoCast()
	thisEntity:SetContextThink( "AutocastAI", AutocastAIThink , 0.1)
end

function AutocastAIThink()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion()  then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 0.1
	end

	local target

	if ABILITY_Heal:GetAutoCastState() and ABILITY_Heal:IsFullyCastable() then 
		local targets = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, ABILITY_Heal:GetCastRange(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

		for k,unit in pairs(targets) do 
			if unit:GetHealthPercent() ~= 100 then 
				if target == nil or target:GetHealthPercent() > unit:GetHealthPercent() then
					target = unit 
				end
			end
		end

		if target then 
			ExecuteOrderFromTable({
 				UnitIndex = thisEntity:entindex(), 
 				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
 		 		TargetIndex = target:entindex(), 
 				AbilityIndex = ABILITY_Heal:entindex(), 
 			})
		end
	end

	return 0.5
end