function Regeneration( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities

	for _,v in pairs(targets) do
			local effect = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			v:Heal(99999, caster)	
			v:GiveMana(99999)
	end
end