warlock_firestorm = class({})
LinkLuaModifier("modifier_warlock_firestorm_burn","heroes/Warlock/modifier_warlock_firestorm_burn.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlock_firestorm_channel","heroes/Warlock/modifier_warlock_firestorm_channel.lua",LUA_MODIFIER_MOTION_NONE)

function warlock_firestorm:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function warlock_firestorm:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "radius_scepter" )
	end

	return self:GetSpecialValueFor( "radius" )
end

function warlock_firestorm:GetChannelTime()
	self.channel_time = self:GetSpecialValueFor( "channel_time" )

	return self.channel_time
end

function warlock_firestorm:OnAbilityPhaseStart()
	EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Start", self:GetCaster() )
	return true	
end

function warlock_firestorm:OnSpellStart()
	self.target_point = self:GetCursorPosition()
	self.channel_time = self:GetSpecialValueFor( "channel_time" )

	self.channel_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_warlock_firestorm_channel", {duration = self.channel_time})	
end

function warlock_firestorm:OnChannelFinish(bInterrupted)
	self.channel_modifier:Destroy()
end