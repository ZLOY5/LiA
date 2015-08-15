function Reborn(event)
	local caster = event.caster
	local owner = caster:GetOwnerEntity()
	local point = caster:GetAbsOrigin()
	local ability = event.ability
	local ability_level = ability:GetLevel()
	local unit_name = "keeper_of_the_grove_young_treant"
	local count = 2

	local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, point )
	ParticleManager:SetParticleControl( particle1, 1, point )
	ParticleManager:SetParticleControl( particle1, 2, Vector(100,0,0) )
	caster:EmitSound("Hero_Furion.ForceOfNature")
	for i=1,count do
		local kotg_reborn_treant = CreateUnitByName(unit_name, point, true, caster, caster:GetOwner(), caster:GetTeam())
		kotg_reborn_treant:SetControllableByPlayer(owner:GetPlayerID(), true)
	end
end