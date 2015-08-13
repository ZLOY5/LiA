function SummonTreants(event)
	local point = event.target_points[1]
	local ability = event.ability
	local ability_level = ability:GetLevel()
	local unit_name = "keeper_of_the_grove_treant_"..ability_level
	local count = 2

	local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, point )
	ParticleManager:SetParticleControl( particle1, 1, point )
	ParticleManager:SetParticleControl( particle1, 2, Vector(100,0,0) )

	for i=1,count do
		kotg_treant = CreateUnitByName(unit_name, point, true, event.caster, event.caster, event.caster:GetTeam())
		kotg_treant:SetControllableByPlayer(event.caster:GetPlayerID(), true)
	end
end