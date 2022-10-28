huntress_moon_rite = class({})
LinkLuaModifier("modifier_huntress_moon_rite","heroes/Huntress/modifier_huntress_moon_rite.lua",LUA_MODIFIER_MOTION_NONE)

function huntress_moon_rite:OnSpellStart() 
	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_huntress_moon_rite", {duration = duration})
		local particle = ParticleManager:CreateParticle("particles/luna_eclipse_small.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(particle)
	
		EmitSoundOn("Hero_Luna.Eclipse.Cast", caster)
	end
end