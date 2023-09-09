firelord_flame_strike = class({})
LinkLuaModifier("modifier_firelord_flame_strike_thinker", "heroes/Firelord/modifier_firelord_flame_strike_thinker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_firelord_flame_strike_burn", "heroes/Firelord/modifier_firelord_flame_strike_burn.lua", LUA_MODIFIER_MOTION_NONE)

function firelord_flame_strike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function firelord_flame_strike:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function firelord_flame_strike:OnSpellStart()
	local caster = self:GetCaster()

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Invoker.SunStrike.Charge", caster)
	
	local pFX = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line_ground.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pFX, 0, self:GetCursorPosition())
	ParticleManager:ReleaseParticleIndex(pFX)
end

function firelord_flame_strike:OnChannelFinish(bInterrupted)
	if not bInterrupted then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("first_strike_duration") + self:GetSpecialValueFor("burn_duration")
	
		local thinker = CreateModifierThinker(caster, self, "modifier_firelord_flame_strike_thinker" , {duration = duration}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
	end
end
