treant_take_root = class({})
LinkLuaModifier("modifier_treant_take_root_root","heroes/Treant/modifier_treant_take_root_root.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_take_root_self","heroes/Treant/modifier_treant_take_root_self.lua",LUA_MODIFIER_MOTION_NONE)

function treant_take_root:OnToggle()
	self.caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.root_duration = self:GetSpecialValueFor( "root_duration" )

	if self:GetToggleState() then 

		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.caster:GetAbsOrigin(),
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

		for _,v in pairs(targets) do
			v:AddNewModifier(self.caster, self, "modifier_treant_take_root_root", {duration = self.root_duration})

		end
	
		self.caster:AddNewModifier(self:GetCaster(), self, "modifier_treant_take_root_self", nil)

		local particleName = "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf"

		self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self.caster)
		ParticleManager:SetParticleControl( self.FXIndex, 0, self.caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex(self.FXIndex)

		EmitSoundOn( "Hero_Treant.Overgrowth.Cast", self.caster )
	else 
		self.caster:RemoveModifierByName("modifier_treant_take_root_self")
		EmitSoundOn( "Hero_Treant.NaturesGuise.Off", self.caster ) 
	end
	

	
end
