function OnOrbImpact(event)
	if event.attacker:GetTeam() ~= event.target:GetTeam() then
	 	event.attacker:Heal(event.damage*event.lifesteal_percent*0.01,event.attacker)
	 	lifestealParticle = ParticleManager:CreateParticle( 'particles/generic_gameplay/generic_lifesteal.vpcf', PATTACH_ABSORIGIN, event.attacker)
        lifestealPos = event.attacker:GetOrigin()
        ParticleManager:SetParticleControl( lifestealParticle, 4, Vector( lifestealPos.x, lifestealPos.y, lifestealPos.z) )
	end
end