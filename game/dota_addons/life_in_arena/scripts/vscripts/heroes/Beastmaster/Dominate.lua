function Dominate(keys)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") and not v:IsHero() then --проверяем не босс или не мегабосс ли юнит
			local name = v:GetUnitName()
			local location = v:GetAbsOrigin()
			local predeath_hp = v:GetHealth()
			if string.find(v:GetUnitName(),"wave_creep") then
					bmcreep = CreateUnitByName(tostring(WAVE_NUM).."_bm", location, false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
					else bmcreep = CreateUnitByName(name, location, false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
			end
			v:AddNoDraw()
			bmcreep:SetHealth(predeath_hp)
			bmcreep:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
			v:Kill(keys.ability, keys.caster)
			else ApplyDamage({victim = v, attacker = keys.caster, damage = keys.ability:GetLevelSpecialValueFor("damage", keys.ability:GetLevel() - 1 ), damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ablility})
		end
	end 
end
