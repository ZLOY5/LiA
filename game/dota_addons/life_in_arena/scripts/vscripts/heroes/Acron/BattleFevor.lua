function Sound(event)
	local caster = event.caster
	local targets = event.target_entities

	local sound_count = 0
	for _,v in pairs(targets) do
		sound_count = sound_count + 1
	end
	if sound_count > 0 then
		caster:EmitSound("Hero_Batrider.Flamebreak.Impact")
	end

end
