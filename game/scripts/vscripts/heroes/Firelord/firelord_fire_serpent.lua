firelord_fire_serpent = class({})

function firelord_fire_serpent:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function firelord_fire_serpent:OnSpellStart()
	self.target_point = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor("duration")
	self.serpent_count = self:GetSpecialValueFor("serpent_count")

	if self:GetCaster():HasScepter() then
		self.serpent = {"npc_serpent_ward_2", "npc_serpent_ward_3", "npc_serpent_ward_4"}
	else
		self.serpent = {"npc_serpent_ward_1", "npc_serpent_ward_2", "npc_serpent_ward_3"}
	end

	local serpent_to_spawn = self.serpent[self:GetLevel()]
	local caster = self:GetCaster()
	for i=1,self.serpent_count do
		local creature = CreateUnitByName(serpent_to_spawn, self.target_point, false, caster, caster, caster:GetTeam())
		creature:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
		creature:AddNewModifier(caster, nil, "modifier_kill", { duration = self.duration })
		creature:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(creature:GetAbsOrigin(),65)
	end

	EmitSoundOn("Hero_ShadowShaman.SerpentWard",self:GetCaster())
end