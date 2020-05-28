walking_dead_decay = class({})
LinkLuaModifier("modifier_walking_dead_decay_self","heroes/WalkingDead/modifier_walking_dead_decay_self.lua",LUA_MODIFIER_MOTION_NONE)

function walking_dead_decay:OnToggle()
	self.caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.root_duration = self:GetSpecialValueFor( "root_duration" )

	if self:GetToggleState() then 

	
		self.caster:AddNewModifier(self:GetCaster(), self, "modifier_walking_dead_decay_self", nil)

		-- local particleName = "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf"

		-- self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self.caster)
		-- ParticleManager:SetParticleControl( self.FXIndex, 0, self.caster:GetAbsOrigin() )
		-- ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
		-- ParticleManager:ReleaseParticleIndex(self.FXIndex)

		-- EmitSoundOn( "Hero_Treant.Overgrowth.Cast", self.caster )
	else 
		self.caster:RemoveModifierByName("modifier_walking_dead_decay_self")
		-- EmitSoundOn( "Hero_Treant.NaturesGuise.Off", self.caster ) 
	end
	

	
end
