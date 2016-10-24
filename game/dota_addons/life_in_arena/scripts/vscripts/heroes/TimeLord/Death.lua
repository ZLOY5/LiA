function Death(event)
	local targets = event.target_entities
	for _,target in pairs(targets) do
		if not string.find(target:GetUnitName(),"boss") then --проверяем не босс или не мегабосс ли юнит
			target:Kill(event.ability, event.caster)
		--	ApplyDamage({victim = target, attacker = event.caster, damage = 99999, damage_type = DAMAGE_TYPE_PURE, ability = event.ability})
		end
	end 
end
