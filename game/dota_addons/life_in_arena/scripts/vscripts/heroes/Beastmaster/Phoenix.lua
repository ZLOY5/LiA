function SpawnEgg(event)
	local hero = event.caster:GetOwnerEntity()
	event.caster:AddNoDraw()
	if not event.caster.cleanerKilled then
		local dummy = CreateUnitByName("npc_dummy_blank", event.caster:GetAbsOrigin(), true, event.caster, nil, event.caster:GetTeam())
		local egg = CreateUnitByName("phoenix_egg_bm", dummy:GetAbsOrigin(), false, hero, hero, event.caster:GetTeam())
		egg:SetControllableByPlayer(hero:GetPlayerID(), true)
		dummy:RemoveSelf()
	end
end

function SpawnPhoenix(event)
	local hero = event.caster:GetOwnerEntity()
	if  not event.caster.cleanerKilled then
		event.caster:AddNoDraw()
		local phoenix = CreateUnitByName("phoenix_bm", event.caster:GetAbsOrigin(), true, hero, hero, event.caster:GetTeam())	
		phoenix:SetControllableByPlayer(hero:GetPlayerID(), true)
		event.caster:Kill(event.ability, event.caster)
	end
end

