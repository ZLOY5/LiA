minotaur_guardian_spirits = class({})
LinkLuaModifier("modifier_minotaur_guardian_spirits","heroes/Minotaur/modifier_minotaur_guardian_spirits.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_minotaur_guardian_spirits_status_effect","heroes/Minotaur/modifier_minotaur_guardian_spirits_status_effect.lua",LUA_MODIFIER_MOTION_NONE)


function minotaur_guardian_spirits:OnSpellStart()
	

	self.invulnerability_duration = self:GetSpecialValueFor("invulnerability_duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_minotaur_guardian_spirits", {duration = self.invulnerability_duration})
	



	-- local particleName = "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"

	-- self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	-- ParticleManager:SetParticleControl( self.FXIndex, 0, caster:GetAbsOrigin() )
	-- ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_ElderTitan.AncestralSpirit.Cast", self:GetCaster() )
end
