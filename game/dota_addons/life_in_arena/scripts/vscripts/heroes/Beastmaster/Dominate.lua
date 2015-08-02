function Dominate(keys)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") then --проверяем не босс или не мегабосс ли юнит
			local name = v:GetUnitName()
			local location = v:GetAbsOrigin()
			if string.find(v:GetUnitName(),"wave_creep") then
				bmcreep = CreateUnitByName(tostring(WAVE_NUM).."_bm", location, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
				else bmcreep = CreateUnitByName(name, location, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
			end
			bmcreep:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
			v:Kill(keys.ability, keys.caster)
		end
	end 
end
