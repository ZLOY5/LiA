necromancer_walking_corpses = class({})

function necromancer_walking_corpses:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function necromancer_walking_corpses:OnSpellStart()
	self.target_point = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor("duration")
	self.skeleton_count = self:GetSpecialValueFor("skeleton_count")

	if self:GetCaster():HasScepter() then
		self.skeleton = {"necromancer_skeleton2", "necromancer_skeleton3", "necromancer_skeleton4"}
	else
		self.skeleton = {"necromancer_skeleton1", "necromancer_skeleton2", "necromancer_skeleton3"}
	end

	local skeleton_to_spawn = self.skeleton[self:GetLevel()]
	local caster = self:GetCaster()
	for i=1,self.skeleton_count do
		local creature = CreateUnitByName(skeleton_to_spawn, self.target_point, false, caster, caster, caster:GetTeam())
		creature:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
		creature:AddNewModifier(caster, nil, "modifier_kill", { duration = self.duration })
		creature:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(creature:GetAbsOrigin(),65)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_zombie_spawn.vpcf", PATTACH_CUSTOMORIGIN, creature )
		ParticleManager:SetParticleControl( nFXIndex, 0, creature:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
				
		EmitSoundOn("Undying_Zombie.Spawn",self:GetCaster())
	end

end