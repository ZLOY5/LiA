function spiritCreate(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local durat = keys.durat
	--local count = keys.count
	--
	local PID = caster:GetPlayerOwnerID()
	
    --local playerID =player:GetPlayerID()
	--local target = keys.target --enemy
	--local target = keys.target_entities[1] --enemy
	--local targets = keys.target_entities
	local lvl = ability:GetLevel()-1
	local unitname
	if lvl == 0 then
		unitname = "spirit_of_the_plains1"
	end
	if lvl == 1 then
		unitname = "spirit_of_the_plains2"
	end
	if lvl == 2 then
		unitname = "spirit_of_the_plains3"
	end
	--
	--for i=1,count do
		local cre = CreateUnitByName(unitname, caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		cre:SetControllableByPlayer(PID, false)
		--
		cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
		cre:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
	--end
	
end