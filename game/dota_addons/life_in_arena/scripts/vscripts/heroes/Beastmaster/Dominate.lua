function Dominate(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") and not v:IsIllusion() then --проверяем не босс или не мегабосс ли юнит
			local health = v:GetHealth()
			local forwardVector = v:GetForwardVector() 
			v:AddNoDraw()
			v:Kill(keys.ability, caster)
			
			bmcreep = CreateUnitByName(v:GetUnitName(), v:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			bmcreep:SetForwardVector(forwardVector)
			bmcreep:SetHealth(health)
			bmcreep:SetControllableByPlayer(caster:GetPlayerID(), true)
		else 
			ApplyDamage({victim = v, attacker = caster, damage = keys.ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})
		end
	end 
end
