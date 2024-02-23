butcher_rage = class({})
LinkLuaModifier("modifier_butcher_rage","heroes/Butcher/modifier_butcher_rage.lua",LUA_MODIFIER_MOTION_NONE)

function butcher_rage:OnSpellStart() 
	if IsServer() then
		self.duration = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_butcher_rage", {duration = self.duration})
		EmitSoundOn("Hero_Pudge.Dismember", self:GetCaster())
	end
end
