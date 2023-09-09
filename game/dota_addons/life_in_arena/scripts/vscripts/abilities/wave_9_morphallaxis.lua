
wave_9_morphallaxis = class({})
LinkLuaModifier( "modifier_wave_9_morphallaxis", "abilities/wave_9_morphallaxis.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_9_morphallaxis:GetIntrinsicModifierName()
	return "modifier_wave_9_morphallaxis"
end

--------------------------------------------------------------------------------


modifier_wave_9_morphallaxis = class({})

--------------------------------------------------------------------------------

function modifier_wave_9_morphallaxis:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_9_morphallaxis:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_9_morphallaxis:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self.chance*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_wave_9_morphallaxis:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_9_morphallaxis:OnAttackLanded(params) 
	if IsServer() then
		if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
			if params.target ~= nil and self.pseudo:Trigger() then
				local position = self:GetParent():GetAbsOrigin()
				local caster = self:GetParent()
				if string.find(caster:GetUnitName(),"extreme") then
					morphollaxis_unit = CreateUnitByName("9_wave_creep_extreme", position, false, caster, caster, caster:GetTeamNumber())
				else
					morphollaxis_unit = CreateUnitByName("9_wave_creep", position, false, caster, caster, caster:GetTeamNumber())
				end
				morphollaxis_unit:SetMaximumGoldBounty(0)
				morphollaxis_unit:SetMinimumGoldBounty(0)
				morphollaxis_unit:SetDeathXP(0)
				morphollaxis_unit.giveNoRatingPoints = true
				FindClearSpaceForUnit(morphollaxis_unit,position,true)
				Survival.nCreepsSpawned = Survival.nCreepsSpawned  + 1
				EmitSoundOn( "Hero_Morphling.Replicate", caster )
			end	
		end 
	end
end

--------------------------------------------------------------------------------
