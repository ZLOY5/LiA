wanderer_ghosts = class({})

function wanderer_ghosts:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function wanderer_ghosts:OnSpellStart()
	self.target_point = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor("duration")
	self.ghosts_count = self:GetSpecialValueFor("ghosts_count")

	if self:GetCaster():HasScepter() then
		self.ghosts = {"ghost_2", "ghost_3", "ghost_4"}
	else
		self.ghosts = {"ghost_1", "ghost_2", "ghost_3"}
	end

	local ghost_to_spawn = self.ghosts[self:GetLevel()]
	local caster = self:GetCaster()
	for i=1,self.ghosts_count do
		local creature = CreateUnitByName(ghost_to_spawn, self.target_point, false, caster, caster, caster:GetTeam())
		creature:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
		creature:AddNewModifier(caster, nil, "modifier_kill", { duration = self.duration })
		creature:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(creature:GetAbsOrigin(),65)
	end

	EmitSoundOn("Ability.static.end",self:GetCaster())
end