item_lia_staff_of_life = class({})

LinkLuaModifier("modifier_staff_of_life","items/modifiers/modifier_staff_of_life.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_staff_of_life_effect","items/modifiers/modifier_staff_of_life_effect.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_staff_of_life:GetIntrinsicModifierName()
	return "modifier_staff_of_life"
end

function item_lia_staff_of_life:GetAOERadius()
	return self:GetSpecialValueFor( "ability_radius" )
end

function item_lia_staff_of_life:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "ability_radius" )
	self.target = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor( "ability_duration" )

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do
		if v ~= self:GetCaster() then
			v:AddNewModifier(self:GetCaster(), self, "modifier_staff_of_life_effect", {duration = self.duration})
		end
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_staff_of_life_effect", {duration = self.duration})

	self.staffOfLightParticle = ParticleManager:CreateParticle("particles/custom/items/staff_of_life_cast.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
	ParticleManager:SetParticleControl( self.staffOfLightParticle, 0, self.target )
	ParticleManager:SetParticleControl( self.staffOfLightParticle, 1, Vector( self.radius, 1, 1 ) )
	StartSoundEventFromPosition("Hero_Dazzle.BadJuJu.Cast", self.target)
end											