hermit_astral = class({})
LinkLuaModifier("modifier_hermit_decrepify","heroes/Hermit/modifier_hermit_decrepify.lua",LUA_MODIFIER_MOTION_NONE)

function hermit_astral:CastFilterResultTarget( hTarget )
	local nCasterID = self:GetCaster():GetPlayerOwnerID()
	local nTargetID = hTarget:GetPlayerOwnerID()
	
	--на клиенте невозможно проверить запрещена ли помощь союзникам 26.09.16
	if IsServer() and not hTarget:IsOpposingTeam(self:GetCaster():GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(nTargetID,nCasterID) then 	
		return UF_FAIL_DISABLE_HELP
	end

	return UnitFilter(hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP,
		self:GetCaster():GetTeamNumber() )
end

function hermit_astral:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if target:TriggerSpellAbsorb(self) then
		return 
	end

	local duration = target:IsHero() and self:GetSpecialValueFor("duration_hero") or self:GetSpecialValueFor("duration_other")

	target:EmitSound("Hero_Pugna.Decrepify")
	target:AddNewModifier(caster,self,"modifier_hermit_decrepify",{duration = duration})
end