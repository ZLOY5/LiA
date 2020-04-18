treant_take_root = class({})
LinkLuaModifier("modifier_treant_take_root_root","heroes/Treant/treant_take_root_root.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_take_root_self","heroes/Treant/treant_take_root_self.lua",LUA_MODIFIER_MOTION_NONE)

function treant_take_root:OnSpellStart()
	local caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.root_duration = self:GetSpecialValueFor( "root_duration" )

	if self:GetToggleState() then 

		local targets = FindUnitsInRadius(caster:GetTeamNumber(),
										self:GetCaster():GetAbsOrigin(),
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

		for _,v in pairs(targets) do
			v:AddNewModifier(caster, self, "modifier_treant_take_root_root", {duration = self.root_duration})

		end
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ancient_priestess_mana_shield", nil)
	else 
		self:GetCaster():RemoveModifierByName("modifier_ancient_priestess_mana_shield")
		EmitSoundOn("Hero_Medusa.ManaShield.Off", self:GetCaster())
	end
	

	-- local particleName = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	-- self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	-- ParticleManager:SetParticleControl( self.FXIndex, 0, caster:GetAbsOrigin() )
	-- ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex(self.FXIndex)

	-- EmitSoundOn( "Hero_Pugna.NetherBlast", self:GetCaster() )
end
