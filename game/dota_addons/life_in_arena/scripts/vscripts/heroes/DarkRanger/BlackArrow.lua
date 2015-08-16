function BlackArrow(event)
	local target = event.target
	local name = event.target:GetUnitName()
	local caster = event.caster
	local player = caster:GetPlayerID()
	local location = target:GetAbsOrigin()

	if not string.find(name,"megaboss") then --проверяем не босс или не мегабосс ли юнит
		if string.find(target:GetUnitName(),"wave_creep") then
			rangercreep = CreateUnitByName(tostring(Survival.nRoundNum).."_bm", location, false, caster, caster, caster:GetTeamNumber())
		else 
			rangercreep = CreateUnitByName(name, location, false, caster, caster, caster:GetTeamNumber())
		end
		rangercreep:SetControllableByPlayer(caster:GetPlayerID(), true)

	end
end