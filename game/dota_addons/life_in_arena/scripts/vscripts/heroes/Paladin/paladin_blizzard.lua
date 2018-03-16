paladin_blizzard = class({})
LinkLuaModifier("modifier_paladin_blizzard_thinker", "heroes/Paladin/modifier_paladin_blizzard_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function paladin_blizzard:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function paladin_blizzard:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function paladin_blizzard:OnSpellStart()
	local caster = self:GetCaster()
	local waveCount = self:GetSpecialValueFor(caster:HasScepter() and "wave_count_scepter" or "wave_count")
	local duration = (self:GetSpecialValueFor("wave_interval") * waveCount) + 0.7
	
	local thinker = CreateModifierThinker(caster, self, "modifier_paladin_blizzard_thinker" , {duration = duration}, self:GetCursorPosition(), caster:GetTeamNumber(), false)

	thinker:EmitSoundParams("hero_Crystal.freezingField.wind", 0, 1, duration)
end

