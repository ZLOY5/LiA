function ForceKill(event)
	local targets = event.target_entities
	for _,unit in pairs(targets) do 
		unit:ForceKill(false)
	end
	Survival.barrelExplosions =Survival.barrelExplosions + 1
	event.caster:AddNoDraw()
end