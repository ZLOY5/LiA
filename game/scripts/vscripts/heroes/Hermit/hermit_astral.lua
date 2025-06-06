---@class hermit_astral:CDOTA_Ability_Lua
hermit_astral = class({})
LinkLuaModifier("modifier_hermit_decrepify","heroes/Hermit/hermit_astral.lua",LUA_MODIFIER_MOTION_NONE)

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


---@class modifier_hermit_decrepify:CDOTA_Modifier_Lua
modifier_hermit_decrepify = class({})

function modifier_hermit_decrepify:IsPurgable()
	return true
end

function modifier_hermit_decrepify:IsDebuff()
	return true
end

function modifier_hermit_decrepify:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
 
	return funcs
end

function modifier_hermit_decrepify:CheckState()
	if not IsServer() then return end
	local shouldBeDisarmed = self:GetParent():GetAttackType() ~= "magic"
	local state = {
		[MODIFIER_STATE_DISARMED] = shouldBeDisarmed,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
 
	return state
end

function modifier_hermit_decrepify:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_hermit_decrepify:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hermit_decrepify:OnCreated(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("reduce_spell_damage_pct")
	self.moveSpeedBonus = self:GetAbility():GetSpecialValueFor("reduce_movement_speed")
end

function modifier_hermit_decrepify:OnAttackStart(keys)
    local target = keys.target 
    if target ~= self:GetParent() then return end

    local attacker = keys.attacker
	if not IsServer() then return end
    if attacker:GetAttackType() ~= "magic" then       
        attacker:Interrupt()                           
    end
end

function modifier_hermit_decrepify:OnRefresh(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("reduce_spell_damage_pct")
	self.moveSpeedBonus = self:GetAbility():GetSpecialValueFor("reduce_movement_speed")
end

function modifier_hermit_decrepify:GetModifierMagicalResistanceDecrepifyUnique()
	return self.magicalResistance
end

function modifier_hermit_decrepify:GetModifierMoveSpeedBonus_Percentage()
	return self.moveSpeedBonus
end

function modifier_hermit_decrepify:GetModifierInvisibilityLevel()
	return 0.3*self:GetRemainingTime()/self:GetDuration()+0.3
end

function modifier_hermit_decrepify:GetAbsoluteNoDamagePhysical()
    return 1 
end
