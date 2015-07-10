function ForceKill(event)
	local targets = event.target_entities
	for _,unit in pairs(targets) do 
		unit:ForceKill(false)
	end

	event.caster:AddNoDraw()
end