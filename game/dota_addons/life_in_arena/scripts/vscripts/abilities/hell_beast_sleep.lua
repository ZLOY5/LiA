hell_beast_sleep = class({})

LinkLuaModifier("modifier_hell_beast_sleep","abilities/modifier_hell_beast_sleep.lua",LUA_MODIFIER_MOTION_NONE)

function hell_beast_sleep:CastFilterResultTarget( hTarget )
	local nCasterID = self:GetCaster():GetPlayerOwnerID()
	local nTargetID = hTarget:GetPlayerOwnerID()
	

	--на клиенте невозможно проверить запрещена ли помощь союзникам 26.09.16
	if IsServer() and not hTarget:IsOpposingTeam(self:GetCaster():GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(nTargetID,nCasterID) then 	
		return UF_FAIL_DISABLE_HELP
	end

	return UnitFilter(hTarget,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP,self:GetCaster():GetTeamNumber())

end

function hell_beast_sleep:OnSpellStart()
	local target = self:GetCursorTarget()

	local invulDuration = self:GetSpecialValueFor("duration_invul")
	local duration = target:IsHero() and self:GetSpecialValueFor("duration_hero") or self:GetSpecialValueFor("duration_creep")

	target:AddNewModifier(self:GetCaster(),self,"modifier_hell_beast_sleep",{duration = duration})
	target:AddNewModifier(self:GetCaster(),self,"modifier_invulnerable",{duration = invulDuration})
end