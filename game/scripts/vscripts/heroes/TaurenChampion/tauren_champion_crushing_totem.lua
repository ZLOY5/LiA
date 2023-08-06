tauren_champion_crushing_totem = class({})
LinkLuaModifier("modifier_tauren_champion_crushing_totem","heroes/TaurenChampion/modifier_tauren_champion_crushing_totem.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_crushing_totem:OnSpellStart() 
	if IsServer() then
		self.duration = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tauren_champion_crushing_totem", {duration = self.duration})
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())
	end
end
