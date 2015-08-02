function Dominate(keys)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") then --проверяем не босс или не мегабосс ли юнит
			local name = v:GetUnitName()
			local location = v:GetAbsOrigin()
			v:Kill(keys.ability, keys.caster)
			CreateUnitByName(name, location, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
		end
	end 
end
