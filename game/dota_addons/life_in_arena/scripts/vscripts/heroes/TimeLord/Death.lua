function Death(event)
	local targets = event.target_entities
	for _,target in pairs(targets) do
		if not string.find(target:GetUnitName(),"boss") then --проверяем не босс или не мегабосс ли юнит
			target:Kill(keys.ability, keys.caster)
		end
	end 
end
