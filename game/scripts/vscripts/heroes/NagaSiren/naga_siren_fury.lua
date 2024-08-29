naga_siren_fury = class({}) --@class naga_siren_fury:CDOTA_Ability_Lua

LinkLuaModifier("modifier_naga_siren_fury", "heroes/NagaSiren/modifier_naga_siren_fury", LUA_MODIFIER_MOTION_NONE)

function naga_siren_fury:OnSpellStart()
	local caster = self:GetCaster()
	
	caster:AddNewModifier(caster, self, "modifier_naga_siren_fury", { duration = self:GetSpecialValueFor("AbilityDuration")})
end
