function spiderCreate(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local durat = keys.durat
	--
	local PID = caster:GetPlayerOwnerID()
	
    --local playerID =player:GetPlayerID()
	--local target = keys.target --enemy
	local target = keys.target_entities[1] --enemy
	--local targets = keys.target_entities
	local lvl = ability:GetLevel()-1
	local unitname
	if lvl == 0 then
		unitname = "queen_of_spiders_spider_1"
	end
	if lvl == 1 then
		unitname = "queen_of_spiders_spider_2"
	end
	if lvl == 2 then
		unitname = "queen_of_spiders_spider_3"
	end
	--
	print("caster = ", caster:GetUnitName())
	print("target = ", target:GetUnitName())
	local cre = CreateUnitByName(unitname, target:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	cre:SetControllableByPlayer(PID, false)
	--
	
	cre:AddNewModifier(caster, cre, "modifier_kill", { duration = durat })
	cre:AddNewModifier(caster, cre, "modifier_phased", { duration = 0.03 })
	
	
	--ability:ApplyDataDrivenModifier( caster, cre, 'modifier_infection_expire', {} )
	--ability:ApplyDataDrivenModifier( caster, cre, 'modifier_phased', {duration = 0.03} )


end