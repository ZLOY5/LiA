hermit_summon_water_elemental = class({})

function hermit_summon_water_elemental:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function hermit_summon_water_elemental:OnSpellStart()
	self.duration = self:GetSpecialValueFor("duration")
	self.unit_count = self:GetSpecialValueFor("unit_count")
	self.spawn_radius = self:GetSpecialValueFor("spawn_radius")

	self.caster = self:GetCaster()
	if self.caster:HasScepter() then
		self.water_elemental = {"npc_water_elemental_2", "npc_water_elemental_3", "npc_water_elemental_4"}
		self.unit_count = self:GetSpecialValueFor("unit_count_scepter")
	else
		self.water_elemental = {"npc_water_elemental_1", "npc_water_elemental_2", "npc_water_elemental_3"}
		self.unit_count = self:GetSpecialValueFor("unit_count")
	end

	if not self.caster.summoned_water_elementals then
		self.caster.summoned_water_elementals = {}
	else
		for i=1, #self.caster.summoned_water_elementals do
			if not self.caster.summoned_water_elementals[i]:IsNull() then
				self.caster.summoned_water_elementals[i]:ForceKill(false)
			end
		end
		self.caster.summoned_water_elementals = {}
	end

	local water_elemental_to_spawn = self.water_elemental[self:GetLevel()]
	local front_position = self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * self.spawn_radius
	for i=1,self.unit_count do
		local creature = CreateUnitByName(water_elemental_to_spawn, front_position, false, self.caster, self.caster, self.caster:GetTeam())
		if water_elemental_to_spawn == "npc_water_elemental_4" then
			creature:SetRenderColor(255,0,0)
		end
		creature:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
		creature:AddNewModifier(self.caster, nil, "modifier_kill", { duration = self.duration })
		creature:AddNewModifier(self.caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(creature:GetAbsOrigin(),65)
		table.insert(self.caster.summoned_water_elementals,creature)
	end

end