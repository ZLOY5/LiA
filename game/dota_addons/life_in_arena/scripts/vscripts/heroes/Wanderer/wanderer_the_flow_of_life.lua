wanderer_the_flow_of_life = class({})
LinkLuaModifier("modifier_flow_of_life","heroes/Wanderer/modifier_flow_of_life.lua",LUA_MODIFIER_MOTION_NONE)

function wanderer_the_flow_of_life:GetCooldown( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel )  
end

function wanderer_the_flow_of_life:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_flow_of_life",{duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn("Hero_Treant.LivingArmor.Cast",self:GetCursorTarget())
end