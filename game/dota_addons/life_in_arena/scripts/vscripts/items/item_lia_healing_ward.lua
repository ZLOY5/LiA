item_lia_healing_ward = class({})

function item_lia_healing_ward:OnSpellStart()
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration")
	local dummy = CreateUnitByName("npc_dummy_blank", self:GetCursorPosition(), true, self.caster, nil, self.caster:GetTeam())
	
	local ward = CreateUnitByName("item_lia_healing_ward_unit", dummy:GetAbsOrigin(), false, self.caster, nil, self.caster:GetTeam())
	ward:AddNewModifier(ward, nil, "modifier_kill", {duration = self.duration})
	ward:SetHullRadius(0)
	dummy:RemoveSelf()

	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	if self:GetCurrentCharges() == 0 then
		self:RemoveSelf()
	end
end

